//
//  FullCardVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FullCardVC.h"
#import "UIView+ViewCreator.h"
#import "FullCardView.h"
#import "ShareController.h"
#import "Global.h"
#import "FullCheckInVC.h"
#import "UINavigationItem+CustomBackButton.h"
#import "AddGirlsServices.h"
#import "CoreDataManager.h"
#import "SyncManager.h"
#import "ImageManager.h"

@interface FullCardVC () {
    IBOutlet UIView *_containerView;
    FullCardView *_fullCardView;
}

@end

@implementation FullCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//     downloadImagesFromServerWithUUID
 
    _fullCardView = [FullCardView createView];
    [_containerView addSubview:_fullCardView];
    [_fullCardView setPerson:self.person];
    [_fullCardView setFrame:CGRectMake(0, 64, _containerView.frame.size.width, _containerView.frame.size.height - 64)];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector:@selector(backBarButtonAction)];
    [self makeRightBarButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_fullCardView setPerson:self.person];
//    [_fullCardView reloadTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - creating Bar Buttons

- (void)makeRightBarButtons {
    //creating pen bar button
    UIImage *penButtonImage = [UIImage imageNamed:@"penNavigationBar"];
    UIButton *penButton = [UIButton buttonWithType: UIButtonTypeCustom];

//    [penButton setBackgroundColor:[UIColor greenColor]];
    
    penButton.bounds = CGRectMake(0, 0, 40, 30);
    [penButton setImage:penButtonImage forState:UIControlStateNormal];
    [penButton addTarget:self action:@selector(editTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *penBarButtomItem = [[UIBarButtonItem alloc] initWithCustomView:penButton];
    
    //creating share bar button
    UIImage *shareButtonImage = [UIImage imageNamed:@"shareNavigationBar"];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    [shareButton setBackgroundColor:[UIColor blackColor]];
    
    shareButton.bounds = CGRectMake(0, 0, 40, 30);
    [shareButton setImage:shareButtonImage forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarButtomItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    //creating trash bar button
    UIImage *trashButtonImage = [UIImage imageNamed:@"trashNavigationBar"];
    UIButton *trashButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
//    [trashButton setBackgroundColor:[UIColor blueColor]];
    
    trashButton.bounds = CGRectMake(0, 0, 40, 30);
    [trashButton setImage:trashButtonImage forState:UIControlStateNormal];
    [trashButton addTarget:self action:@selector(deleteTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *trashBarButtomItem = [[UIBarButtonItem alloc] initWithCustomView:trashButton];
    
    //self.navigationItem.rightBarButtonItems set
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:trashBarButtomItem,  shareBarButtomItem, penBarButtomItem, nil];
    //self.navigationItem.rightBarButtonItem = penBarButtomItem;
}

#pragma mark - Private methods

- (void)confirmDeletingWithCompletion:(void (^)(bool delete))completion {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:@"Delete girl?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = RED_COLOR;
    
    UIAlertAction *deleteAction = [UIAlertAction
                                   actionWithTitle:@"Delete"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       completion(YES);
                                       
                                   }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action) {
                                   }];
    
    alertController.view.tintColor = RED_COLOR;
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


#pragma mark - bar buttons actions
- (void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editTapped:(id)sender {
     FullCheckInVC *viewController = (FullCheckInVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"GirlEditor", @"FullCheckInVC");
    viewController.person = self.person;
    viewController.isEditMode = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)shareTapped:(id)sender {
    
    if ([[SyncManager sharedInstance] connected]) {
          [[ShareController sharedInstance] presentShareControllerInViewController:self withPerson:self.person];
    } else {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning!"
                                              message:@"Check your internet connection."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *showWarningAction = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action)
                                            {
                                                
                                            }];
        
        [alertController addAction:showWarningAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        alertController.view.tintColor = RED_COLOR;
    }
}

- (IBAction)deleteTapped:(id)sender {
    
    [self confirmDeletingWithCompletion:^(bool delete) {
        if (delete) {
            self.person.status = @"DEL";
            
            NSError *error = nil;
            
            [MTLManagedObjectAdapter managedObjectFromModel:self.person
                                       insertingIntoContext:[[CoreDataManager instance] managedObjectContext]
                                                      error:&error];
            [[CoreDataManager instance] saveContext];
            
            if ([[SyncManager sharedInstance] connected]) {
                AddGirlsServices *addGirlsServices = [AddGirlsServices new];
                [[addGirlsServices uploadPersons] subscribeCompleted:^(void) {
                    [[ImageManager sharedInstance] deleteAllImagesWithUUID:self.person.uuid];
                    [[CoreDataManager instance] cleanDeletedPerson];
                }];
            } else {
                [SyncManager sharedInstance].checkForPersonsUploading = YES;
            }
            
            [self backBarButtonAction];
        }
    }];
    

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
