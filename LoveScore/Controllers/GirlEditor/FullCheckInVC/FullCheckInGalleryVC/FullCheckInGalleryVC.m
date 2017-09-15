//
//  FullCheckInGalleryVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FullCheckInGalleryVC.h"
#import "FullCheckInGalleryCell.h"
#import "UIView+ViewCreator.h"
#import "FullCheckInFullPhotoViewController.h"
#import "ImageManager.h"
#import "AddPersonImages.h"
#import "PicturesEntity.h"
#import "CoreDataManager.h"

@interface FullCheckInGalleryVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, FullCheckInGalleryCellDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIImage *pickedImage;
@property (strong, nonatomic) NSIndexPath *editableCellIndexPath;

@property (nonatomic) NSNumber *countOfImages;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic, strong) AddPersonImages *addPersonImages;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UICollectionViewCell *currentCell;


@property (nonatomic, strong) NSIndexPath *avatarIndexPath;

@end

@implementation FullCheckInGalleryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addPersonImages = [AddPersonImages new];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FullCheckInGalleryCell" bundle:nil] forCellWithReuseIdentifier:FullCheckInGalleryCellId];
    
    // attach long press gesture to collectionView
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleLongPress:)];
    
    lpgr.minimumPressDuration = .5; //seconds
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:lpgr];
    
    // attach tap GR to collection view
    UITapGestureRecognizer *tpgr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapInView:)];
    [self.collectionView addGestureRecognizer:tpgr];
    
    self.imagesArray = [[ImageManager sharedInstance] getImagesArrayWithUUID:self.person.uuid];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view.superview isKindOfClass:[UITableViewCell class]] || [touch.view.superview isKindOfClass:[UIButton class]]) {
        
        [self.deleteButton removeFromSuperview];
        [[self.currentCell layer] removeAnimationForKey:@"iconShake"];
        
        return NO;
    }
    return YES;
}

- (IBAction)tapInView:(UITapGestureRecognizer *)sender {
    
    CGPoint p = [sender locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (self.editableCellIndexPath) {
        FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)
        [self.collectionView cellForItemAtIndexPath:self.editableCellIndexPath];
        [cell hideMask];
        
        [self.deleteButton removeFromSuperview];
        [[self.currentCell layer] removeAnimationForKey:@"iconShake"];
    }
    
    if (indexPath == nil){

    } else {
        
        if (indexPath.row == self.imagesArray.count) {
            [self openGalleryAction];
            return;
        }
        
        if ([self.editableCellIndexPath isEqual:indexPath]) {
            FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)
            [self.collectionView cellForItemAtIndexPath:self.editableCellIndexPath];
            [cell hideMask];
            
            [self.deleteButton removeFromSuperview];
            [[self.currentCell layer] removeAnimationForKey:@"iconShake"];
            self.editableCellIndexPath = nil;
            
        } else {
            self.editableCellIndexPath = indexPath;
            
            FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)
            [self.collectionView cellForItemAtIndexPath:indexPath];
            [cell showMask];
            
            if (self.avatarIndexPath) {
                if (indexPath.row == self.avatarIndexPath.row) {
                    [cell selectedStar];
                } else {

                    [cell deselectedStar];
                }
            }
            
            cell.delegate = self;
            self.currentIndex = indexPath.row;
        }
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    
        if (self.editableCellIndexPath) {
            FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)
            [self.collectionView cellForItemAtIndexPath:self.editableCellIndexPath];
            [cell hideMask];
            
            [self.deleteButton removeFromSuperview];
            [[self.currentCell layer] removeAnimationForKey:@"iconShake"];
        }
        
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [anim setToValue:[NSNumber numberWithFloat:-M_PI/64]];
        [anim setFromValue:[NSNumber numberWithDouble:M_PI/64]]; // rotation angle
        [anim setDuration:0.1];
        [anim setRepeatCount:NSUIntegerMax];
        [anim setAutoreverses:YES];
        
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        
        if (indexPath == nil || indexPath.row == self.imagesArray.count){
            NSLog(@"couldn't find index path");
        } else {
            if (self.editableCellIndexPath) {
                FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)[self.collectionView cellForItemAtIndexPath:self.editableCellIndexPath];
                
                [cell hideMask];
            }
            
            if ([self.editableCellIndexPath isEqual:indexPath]) {
                FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)
                [self.collectionView cellForItemAtIndexPath:self.editableCellIndexPath];
                [cell hideMask];
                
                [self.deleteButton removeFromSuperview];
                [[self.currentCell layer] removeAnimationForKey:@"iconShake"];
                
                self.editableCellIndexPath = nil;
                
            } else {
                self.editableCellIndexPath = indexPath;
                
                self.currentCell = [self.collectionView cellForItemAtIndexPath:self.editableCellIndexPath];
                
                [[self.currentCell layer] addAnimation:anim forKey:@"iconShake"];
                
                CGRect deleteButtonFrame;
                
//                if (indexPath.row % 3 == 0) {
                    deleteButtonFrame = CGRectMake((self.currentCell.frame.origin.x + self.currentCell.frame.size.width - self.currentCell.frame.size.width / 6) - 8, (self.currentCell.frame.origin.y - self.currentCell.frame.size.height / 6) + 8, self.currentCell.frame.size.width / 3, self.currentCell.frame.size.height / 3);

//                } else {
//                    deleteButtonFrame = CGRectMake(self.currentCell.frame.origin.x - self.currentCell.frame.size.width / 6, self.currentCell.frame.origin.y - self.currentCell.frame.size.height / 6, self.currentCell.frame.size.width / 3, self.currentCell.frame.size.height / 3);
//                }
                
                self.deleteButton= [[UIButton alloc] initWithFrame:deleteButtonFrame];
                
                [[self.deleteButton layer]addAnimation:anim forKey:@"iconShake"];
                
                [self.deleteButton addTarget:self action:@selector(deleteLayer) forControlEvents:UIControlEventTouchUpInside];
                
                [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"whiteDeleteButton"] forState:UIControlStateNormal];
                
                [self.deleteButton removeFromSuperview];
                [self.collectionView addSubview:self.deleteButton];
                
                [self.collectionView cellForItemAtIndexPath:indexPath];
            }
        }
    }
}

- (void)deleteLayer {
    // TODO:Add reachability
    
    NSString *path = [self.imagesArray objectAtIndex:self.editableCellIndexPath.row];
    [[ImageManager sharedInstance] deleteImageWithPath:path];
    
    NSString *nameToDelete = [path lastPathComponent];
    nameToDelete = [nameToDelete stringByReplacingOccurrencesOfString:@".png" withString:@""];
    nameToDelete = [nameToDelete stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([[SyncManager sharedInstance] connected]) {
        
        NSArray *array = [[NSArray alloc] initWithObjects:nameToDelete, nil];
        
        [[self.addPersonImages deletePhotoWithPersonId:self.person.uuid andImagesArrayId:array
          ]  subscribeError:^(NSError *error) {
            
        } completed:^(void) {
            
        }];
        
    } else {
        [[ImageManager sharedInstance].deleteImagesDictionaries setObject:nameToDelete forKey:self.person.uuid];
        [[SyncManager sharedInstance] setCheckForImagesUploading:YES];
    }
    
    [self.deleteButton removeFromSuperview];
    [[self.currentCell layer] removeAnimationForKey:@"iconShake"];
    
    //    self.currentCell
    
    self.imagesArray = [[ImageManager sharedInstance] getImagesArrayWithUUID:self.person.uuid];
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.imagesArray.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FullCheckInGalleryCell *cell = [cv dequeueReusableCellWithReuseIdentifier:FullCheckInGalleryCellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [FullCheckInGalleryCell createView];
    }
    
    if (self.imagesArray.count > 0 && indexPath.row < self.imagesArray.count) {
        
        if (indexPath.row == self.imagesArray.count - 1) {
            self.lastIndexPath = indexPath;
        }
        
        UIImage *image = [UIImage imageWithContentsOfFile:self.imagesArray[indexPath.row]];
        
        NSString *name = [[ImageManager sharedInstance].avatarDictionaries objectForKey:self.person.uuid];
        
        name = [name stringByReplacingOccurrencesOfString:@"star" withString:@""];
        
        if ([self.imagesArray[indexPath.row] isEqualToString:name]) {
            
            self.avatarIndexPath = indexPath;
        }
        
        [cell setPhotoImage: image];
    } else {
        [cell setupAddButton];
    }
    
    return cell;
}

#pragma mark - Delegate and method for opening

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.lastIndexPath];
    
    NSArray *array = [NSArray arrayWithObjects:_pickedImage, nil];
    NSString *imageName = nil;
    
    imageName = [[ImageManager sharedInstance] saveImage:_pickedImage withUUID:self.person.uuid];
    
    PicturesEntity *picturesEntity = (PicturesEntity *)[[CoreDataManager instance] insertNewManagedObject:@"Pictures"];
    picturesEntity.uuid = self.person.uuid;
    [[CoreDataManager instance] saveContext];
    
    if ([[SyncManager sharedInstance] connected]) {
        [[self.addPersonImages uploadImage:array
                                    inView:nil
                                   forUUID:self.person.uuid
                               imagesNames:@[imageName]]
         subscribeCompleted:^(void) {
             
         }];
    } else {
        
        if ([[ImageManager sharedInstance].imagesToUpload objectForKey:self.person.uuid]) {
            
            [[[ImageManager sharedInstance].imagesToUpload objectForKey:self.person.uuid] addObject:imageName];
        } else {
            NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:imageName, nil];
            
            [[ImageManager sharedInstance].imagesToUpload setObject:array forKey:self.person.uuid];
        }
        
        [SyncManager sharedInstance].checkForImagesUploading = YES;
    }
    
    self.imagesArray = [[ImageManager sharedInstance] getImagesArrayWithUUID:self.person.uuid];
    [self.collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)openGalleryAction {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil                                                                            message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    [_imagePickerController setAllowsEditing:YES];
    
    alertController.view.tintColor = RED_COLOR;
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel");
                                   }];
    
    UIAlertAction *openGallery = [UIAlertAction
                                  actionWithTitle:@"Open Gallery"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                      
                                      [self presentViewController:_imagePickerController animated:YES completion:nil];
                                  }];
    
    UIAlertAction *openCamera = [UIAlertAction
                                 actionWithTitle:@"Open Camera"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action)
                                 {
                                     NSString *model = [[UIDevice currentDevice] model];
                                     if (![model isEqualToString:@"iPhone Simulator"]) {
                                         if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                                             _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                             [self presentViewController:self.imagePickerController animated:YES completion:nil];
                                         }
                                         else
                                             [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Camera is not suuported on this device."];                                     }
                                 }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:openGallery];
    [alertController addAction:openCamera];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *) indexPath {
//
//    if (self.editableCellIndexPath) {
//        FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)
//        [self.collectionView cellForItemAtIndexPath:self.editableCellIndexPath];
//        [cell hideMask];
//    }
//
//    if (indexPath.row == self.imagesArray.count) {
//        [self openGalleryAction];
//        return;
//    }
//
//    self.editableCellIndexPath = indexPath;
//
//    FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)
//    [self.collectionView cellForItemAtIndexPath:indexPath];
//    [cell showMask];
//    cell.delegate = self;
//    self.currentIndex = indexPath.row;
//
//    //    [self performSegueWithIdentifier:@"Gallery@FullPhoto" sender:self];
//}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 3 - 2, [UIScreen mainScreen].bounds.size.width / 3 - 2);
    
    return itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section  {
    return 1.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (void)starButtonAction {
    
    if (self.editableCellIndexPath) {
        FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)
        [self.collectionView cellForItemAtIndexPath:self.editableCellIndexPath];
        self.avatarIndexPath = self.editableCellIndexPath;
        
        [cell selectedStar];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [cell hideMask];
        });
    }
    
    [[ImageManager sharedInstance] makeImageAvatarOnPath:self.imagesArray[self.editableCellIndexPath.row] withUUID:self.person.uuid];
    
    if ([_delegate respondsToSelector:@selector(avatarWasChanged)]) {
        [_delegate avatarWasChanged];
    }
}

- (void)galleryButtonAction {
    if (self.editableCellIndexPath) {
        FullCheckInGalleryCell *cell = (FullCheckInGalleryCell *)
        [self.collectionView cellForItemAtIndexPath:self.editableCellIndexPath];
        [cell hideMask];
    }
    
    [self performSegueWithIdentifier:@"Gallery@FullPhoto" sender:self];
}

#pragma mark - Load images methods

//
//- (UIImage*)loadImageWithNumber:(NSNumber *)index {
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString* path = [documentsDirectory stringByAppendingPathComponent:self.person.uuid];
//
//    NSString *imageName = [[index stringValue] stringByAppendingString:@".png"];
//    path = [path stringByAppendingPathComponent:imageName];
//
//    UIImage* image = [UIImage imageWithContentsOfFile:path];
//    return image;
//}
//
//- (void)saveImage:(UIImage*)image {
//
//    if (image != nil) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                             NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *path = [documentsDirectory stringByAppendingPathComponent:self.person.uuid];
//
//        NSError *error;
//        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
//            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
//
//        self.countOfImages = [NSNumber numberWithInt:[self.countOfImages intValue] + 1];
//
//        NSString *imageName = [[self.countOfImages stringValue] stringByAppendingString:@".png"];
//
//        path = [path stringByAppendingPathComponent:imageName];
//
//        NSData *data = UIImagePNGRepresentation(image);
//        [data writeToFile:path atomically:YES];
//    }
//}
//
//- (void)calculateCountOfImages {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:self.person.uuid];
//
//    NSError *error;
//    NSArray *filelist= [fileManager contentsOfDirectoryAtPath:path error:&error];
//
//    if (error) {
//        NSLog(@"Error in gallery - %@", error);
//    }
//
//    self.countOfImages = [NSNumber numberWithInteger:[filelist count]];
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Gallery@FullPhoto"]) {
        FullCheckInFullPhotoViewController *vc = segue.destinationViewController;
        vc.photo = [UIImage imageWithContentsOfFile:self.imagesArray[_currentIndex]];
        
        NSString *titleName = self.person.firstName;
        if (self.person.lastName && self.person.lastName.length > 0) {
            titleName = [titleName stringByAppendingString:@" "];
            titleName = [titleName stringByAppendingString:self.person.lastName];
        }
        
        vc.title = titleName;
    }
}

@end
