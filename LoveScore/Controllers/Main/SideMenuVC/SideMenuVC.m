//
//  SideMenuVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SideMenuVC.h"
#import "SideMenuModel.h"
#import "SideMenuCell.h"
#import "UIView+ViewCreator.h"
#import "ImageManager.h"
#import "WorldScoreVC.h"
#import "SharingServices.h"
#import "FriendsServices.h"
#import "UserServices.h"
#import "SyncManager.h"
#import "CoreDataManager.h"

@interface SideMenuVC () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate > {
    IBOutlet UIButton *_settingsButton;
    
    NSArray *cellNameArray;
    NSArray *cellImagesArray;
    
    IBOutlet UITableView *_tableView;
}

@property (strong, nonatomic) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, strong) UISwipeGestureRecognizer *closeGestureRecoginzer;

@property (strong, nonatomic) IBOutlet UIView *containerViewForButton;
@property (strong, nonatomic) UIButton *deleteButton;

@property (strong, nonatomic) SharingServices *sharingServ;
@property (strong, nonatomic) FriendsServices *friendsSev;

@property (nonatomic, strong) UserServices *userServices;
@end

@implementation SideMenuVC
{
    NSInteger currentElement;
}

#pragma mark - load methods

- (void)viewDidLoad {
    [super viewDidLoad];
    currentElement = MyGirlSideMenuElement;
    
    self.userServices = [UserServices new];
    
    [self setup];
    
    self.avatarButton.layer.cornerRadius = self.avatarButton.frame.size.height / 2;
    self.avatarButton.clipsToBounds = YES;
    
    [self.avatarButton setContentMode:UIViewContentModeScaleAspectFill];
    [self.avatarButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.closeGestureRecoginzer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideMenu)];
    [self.closeGestureRecoginzer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:self.closeGestureRecoginzer];
    self.newFriend = NO;
    self.newInbox = NO;
    self.sharingServ = [SharingServices new];
    self.friendsSev = [FriendsServices new];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.nameLabel setText:_userName];
    
    if (_avatarImage) {
        [self setupLongPress];
        [self.avatarButton setImage:_avatarImage forState:UIControlStateNormal];
    }
    [[self.sharingServ getRetrieveInboxWithLimit:25 andWithPage:1 savingToDatabase:NO] subscribeNext:^(id x) {
        NSInteger count = 0;
        NSArray *income = [[x objectForKey:@"data"] objectForKey:@"incoming"];
        for (NSDictionary *inboxItem in income) {
            if ([[inboxItem objectForKey:@"status"] isEqualToString:@"RCV"]) {
                count++;
            }
        }
        if (income.count != count) {
            [[SideMenuModel sharedInstance]sideMenuVC].newInbox = YES;
        } else {
            [[SideMenuModel sharedInstance] sideMenuVC].newInbox = NO;
        }
        [_tableView reloadData];

         }];
    [[self.friendsSev getIncomingFriendsWithLimit:@"25" andWithPage:@"1" savingToDatabase:NO] subscribeNext:^(id x) {
        NSArray *friendRequests = [x objectForKey:@"data"];
        if (friendRequests && friendRequests.count > 0) {
            [[SideMenuModel sharedInstance] sideMenuVC].newFriend = YES;
        } else {
            [[SideMenuModel sharedInstance] sideMenuVC].newFriend = NO;
        }
        [_tableView reloadData];
    }];
    
    
}

- (void)setup {
    cellNameArray = [[NSArray alloc] initWithObjects:@"ADD GIRL", @"MY GIRLS", @"WORLD SCORE", @"STATISTICS", @"INBOX", @"FRIENDS", nil];
    //@"LUCKY LIST"       Omitted by Dany Iliev, 21.08/2017 18:54:00

    cellImagesArray = [[NSArray alloc] initWithObjects:@"side-menu-icon-girl-plus", @"side-menu-icon-girl", @"side-menu-icon-globe", @"side-menu-icon-statistics", @"side-menu-icon-list", @"side-menu-icon-lovebox", @"side-menu-icon-friends", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)settingsButtonAction:(UIButton *)sender {
    currentElement = -1;
    
    [self performSegueWithIdentifier:@"@Settings" sender:self];
    
    // change state from "Open" to "Close"
    [[SideMenuModel sharedInstance] changeSideMenuState];
}

- (IBAction)avatarButtonAction:(UIButton *)sender {
    
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
                                             [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Camera is not suuported on this device."];
                                     }
                                     
                                 }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:openGallery];
    [alertController addAction:openCamera];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

#pragma mark - table view delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
    // Modified from 7 to 6 by Dany Iliev, 21.08/2017 18:54:00
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return 51.f;
    return tableView.frame.size.height / 7;
    // Modified from 8 to 7 by Dany Iliev, 21.08/2017 18:54:00
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *MyIdentifier = SideMenuCellId;
    
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [SideMenuCell createView];
    }
    
    cell.categoryNameLabel.text = cellNameArray[indexPath.row];
    [cell.iconImageView setImage:[UIImage imageNamed:cellImagesArray[indexPath.row]]];
    
    if (indexPath.row == InboxSideMenuElement) {
        [cell.notificationMark setHidden:!self.newInbox];
    }
    if (indexPath.row == FriendsSideMenuElement) {
        [cell.notificationMark setHidden:!self.newFriend];
    }
    
    if (indexPath.row == 5) {    // Modified from 6 to 5 by Dany Iliev, 21.08/2017 18:54:00
        [cell removeSeparator];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (currentElement == indexPath.row) {
//        [[SideMenuModel sharedInstance] anchorRight];
//        return;
//    }
    
    currentElement = indexPath.row;
    
    switch (indexPath.row) {
        case AddGirlSideMenuElement: {
            [self performSegueWithIdentifier:@"@GirlEditor" sender:self];
        }
            break;
        case MyGirlSideMenuElement: {
            [self performSegueWithIdentifier:@"MyGirlNavigationControllerSegue" sender:self];
        }
            break;
        case WorldScoreSideMenuElement: {
            [self performSegueWithIdentifier:@"@WorldScore" sender:self];
        }
            break;
        case StaticsSideMenuElement: {
            [self performSegueWithIdentifier:@"@Statistics" sender:self];
        }
            break;
//        Marked by Dany Iliev, 21.08/2017 18:54:00
//        case LuckyListSideMenuElement: {
//            [self performSegueWithIdentifier:@"LuckyListNavigationControllerSegue" sender:self];
//        }
//            break;
//        End Marked
        case InboxSideMenuElement: {
            [self performSegueWithIdentifier:@"InboxNavigationControllerSegue" sender:self];
        }
            break;
        case FriendsSideMenuElement: {
            [self performSegueWithIdentifier:@"@Friends" sender:self];
        }
            break;
        default: {
            
        }
            break;
    }
    
    // change state from "Open" to "Close"
    [[SideMenuModel sharedInstance] changeSideMenuState];
}

// select selection color when press on the cell
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:240.f/255.f alpha:0.1f]];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ImagePickerController Delegate and method for opening

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.avatarImage = avatarImage;

    if ([[SyncManager sharedInstance] connected]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            [[self.userServices uploadAvatarImage:avatarImage inView:self.avatarButton]
             subscribeError:^(NSError *error) {
                 
             }
             completed:^(void) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^(void) {
                     
                     [self setupLongPress];
                     [self.avatarButton setImage:avatarImage forState:UIControlStateNormal];
                 });
             }];
        });
        
    } else {
        [SyncManager sharedInstance].checkForAvatarUploading = YES;
    }
    
    [[ImageManager sharedInstance] saveUserAvatar:avatarImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public methods

- (void)performSegueWithID:(NSString *)identifier  {
    [self performSegueWithIdentifier:identifier sender:self];

}


- (void)setUserName:(NSString *)userName {
    _userName = userName;
    
    [self.nameLabel setText:userName];
}

- (void)setAvatarImage:(UIImage *)avatarImage {
    _avatarImage = avatarImage;
    
    if (avatarImage) {
        [self setupLongPress];
        [self.avatarButton setImage:avatarImage forState:UIControlStateNormal];
    }
}

- (void)setupLongPress {
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleLongPress:)];
    
    _longPressGestureRecognizer.delegate = self;
    [self.avatarButton addGestureRecognizer:_longPressGestureRecognizer];
}

#pragma mark - Private methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view.superview isKindOfClass:[UITableViewCell class]] || [touch.view.superview isKindOfClass:[UIButton class]]) {
        
        [self.deleteButton removeFromSuperview];
        [[self.containerViewForButton layer] removeAnimationForKey:@"iconShake"];
        
        return NO;
    }
    return YES;
}

- (IBAction)tapInView:(UITapGestureRecognizer *)sender {
    
    //    if([self.containerViewForButton isDescendantOfView:self.deleteButton]) {
    [self.deleteButton removeFromSuperview];
    [[self.containerViewForButton layer] removeAnimationForKey:@"iconShake"];
    //    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [anim setToValue:[NSNumber numberWithFloat:0.0f]];
        [anim setFromValue:[NSNumber numberWithDouble:M_PI/16]]; // rotation angle
        [anim setDuration:0.1];
        [anim setRepeatCount:NSUIntegerMax];
        [anim setAutoreverses:YES];
        [[self.containerViewForButton layer] addAnimation:anim forKey:@"iconShake"];
        
        CGRect deleteButtonFrame = CGRectMake(self.avatarButton.frame.origin.x, self.avatarButton.frame.origin.y, self.avatarButton.frame.size.width / 4, self.avatarButton.frame.size.height / 4);
        
        self.deleteButton= [[UIButton alloc] initWithFrame:deleteButtonFrame];
        
        [self.deleteButton addTarget:self action:@selector(deleteLayer) forControlEvents:UIControlEventTouchUpInside];
        
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"whiteDeleteButton"] forState:UIControlStateNormal];
        
        [self.deleteButton removeFromSuperview];
        [self.containerViewForButton addSubview:self.deleteButton];
        
    }
}


- (void)deleteLayer {
    // TODO:Add reachability
    
    [self.deleteButton removeFromSuperview];
    [[self.containerViewForButton layer] removeAnimationForKey:@"iconShake"];
    
    [self.avatarButton setImage:[UIImage imageNamed:@"male-avatar"] forState:UIControlStateNormal];
    
    [[self.userServices removeUserImage] subscribeError:^(NSError *error) {
        [self showAlertControllerWithTitle:@"Warning" withMessage:@"Image couldn't be deleted"];
        
    } completed:^(void) {
    }];
    
    [[ImageManager sharedInstance] deleteUserAvatar];
}

- (void)closeSideMenu {
    [[SideMenuModel sharedInstance] anchorRight];
    //        [[SideMenuModel sharedInstance] changeSideMenuState];
}

- (void)dealloc {
    //    [self.view removeGestureRecognizer:self.closeGestureRecoginzer];
}

@end
