//
//  FullCheckInVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FullCheckInVC.h"
#import "FullCheckInFullPhotoViewController.h"
#import "UINavigationItem+CustomBackButton.h"
#import "FullCheckInVCProtocol.h"
#import "FullCheckInGeneralVC.h"
#import "FullCheckInSpecialsVC.h"
#import "Person.h"
#import "PersonEntity.h"
#import "FullCheckInGalleryVC.h"
#import "CoreDataManager.h"
#import "AddGirlsServices.h"
#import "SideMenuModel.h"
#import "SyncManager.h"
#import "SendToVC.h"

#import "ImageManager.h"
#import "FullCheckInFullPhotoViewController.h"

@interface FullCheckInVC ()<FullCheckInGalleryDelegate> {
    
}

@property (strong, nonatomic)AddGirlsServices *addGirlServices;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UIViewController<FullCheckInVCProtocol> *currentViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;

@end

@implementation FullCheckInVC

#pragma mark - lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isEditMode) {
        [self.checkInButton setTitle:@"SAVE"];
    } else {
        [self.checkInButton setTitle:@"CHECK IN"];
    }
    
    self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ComponentA"];
    
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    self.currentViewController.person = self.person;
    
    self.navigationItem.hidesBackButton = YES;
    //    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    [self makeRightBarButton];
    self.addGirlServices = [AddGirlsServices new];
}

#pragma mark - Public

- (void)setPerson:(Person *)person {
    _person = person;
    
    NSString *titleName = person.firstName;
    if (self.person.lastName && self.person.lastName.length > 0) {
        titleName = [titleName stringByAppendingString:@" "];
        titleName = [titleName stringByAppendingString:self.person.lastName];
    }
    
    self.navigationItem.title = titleName;
}

- (void)showSimpleAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = RED_COLOR;
    
    
    UIAlertAction *okayAction = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *action)
                                 {
                                 }];
    
    [alertController addAction:okayAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private

- (BOOL)isEnteredDataValid {
    
    BOOL isInputDataValid = YES;
    
    if ([self.person.firstName isEqualToString:@""]) {
        
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please add the girl's name."];
        isInputDataValid = NO;
    }
    
    if (self.person.firstName.length < 3 || self.person.firstName.length >= 25) {
        
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please adjust girl's name."];
        isInputDataValid = NO;
    }
    
    {
        NSMutableCharacterSet *set = [[NSCharacterSet letterCharacterSet] mutableCopy];
        [set formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        if ([self.person.firstName rangeOfCharacterFromSet:[set invertedSet]].location != NSNotFound) {
            isInputDataValid = NO;
            
            [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please adjust girl's name."];
        }
    }
    
    if (self.person.lastName && self.person.lastName.length < 3) {
        
        [self showSimpleAlertControllerWithTitle:@"Sorry!" andMessage:@"Last name should be bigger than 2 symbols"];
        isInputDataValid = NO;
    }
    
    {
        NSMutableCharacterSet *set = [[NSCharacterSet letterCharacterSet] mutableCopy];
        [set formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        if (self.person.lastName && [self.person.lastName rangeOfCharacterFromSet:[set invertedSet]].location != NSNotFound) {
            isInputDataValid = NO;
            [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please adjust girl's name."];
        }
    }
    
    if ([self.person.country isEqualToString:@""] || [self.person.country isEqualToString:@"Country"]) {
        
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please add a nationality"];
        isInputDataValid = NO;
    }
    
    if ([[self.person.age stringValue] isEqualToString:@""]) {
        
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@" Please add the girl's age."];
        isInputDataValid = NO;
    } else {
        NSInteger age = [self.person.age integerValue];
        
        if (age < 16 || age > 99) {
            [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Please adjust age"];
            isInputDataValid = NO;
        }
    }
    

    id dateDate = [self.person.events objectForKey:@"DATE"];
    id kissDate = [self.person.events objectForKey:@"KISS"];
    id loveDate = [self.person.events objectForKey:@"LOVE"];
    if (!dateDate && !kissDate && !loveDate) {
        isInputDataValid = NO;
        [self showSimpleAlertControllerWithTitle:@"" andMessage:@"Which item fits best for your event?"];
    }
    
    return isInputDataValid;
}

- (void)cycleFromViewController:(UIViewController<FullCheckInVCProtocol>*) oldViewController
               toViewController:(UIViewController<FullCheckInVCProtocol>*) newViewController {
    
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    [newViewController.view layoutIfNeeded];
    newViewController.person = self.person;
    
    // set starting state of the transition
    newViewController.view.alpha = 0;
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         
                         [newViewController didMoveToParentViewController:self];
                     }];
}

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}

#pragma mark - IBAction methods
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    [sender setClipsToBounds:NO];
    
    if ([self.currentViewController isKindOfClass:[FullCheckInGeneralVC class]]) {
        [(FullCheckInGeneralVC *)self.currentViewController savePerson];
    } else if ([self.currentViewController isKindOfClass:[FullCheckInGalleryVC class]]) {
        
    } else if ([self.currentViewController isKindOfClass:[FullCheckInSpecialsVC class]]) {
        [(FullCheckInSpecialsVC *)self.currentViewController savePerson];
    }
    
    if (sender.selectedSegmentIndex == 0) {
        UIViewController <FullCheckInVCProtocol>*newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ComponentA"];
        newViewController.person = self.person;
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
        
    }
    if (sender.selectedSegmentIndex == 1) {
        FullCheckInGalleryVC <FullCheckInVCProtocol>*newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ComponentB"];
        newViewController.person = self.person;
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
        ((FullCheckInGalleryVC *)self.currentViewController).delegate = self;
        
    }
    
    if (sender.selectedSegmentIndex == 2) {
        UIViewController <FullCheckInVCProtocol>*newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ComponentC"];
        newViewController.person = self.person;
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
        
    }
    
    self.currentViewController.person = self.person;
}

#pragma mark - Bar Buttons Actions

- (void)makeRightBarButton{
    
    UIImage* buttonImage = [[ImageManager sharedInstance] getAvatarImageForUUID:self.person.uuid];
    
    CGRect frameimg = CGRectMake(5, 0, 31, 31);
    
    UIButton *imageButton = [[UIButton alloc] initWithFrame:frameimg];
    [imageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageButton setContentMode:UIViewContentModeScaleAspectFill];
    imageButton.layer.cornerRadius = imageButton.frame.size.width / 2;
    [imageButton setClipsToBounds:YES];
    [imageButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(imageBarButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *imageBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:imageButton];
    
    self.navigationItem.rightBarButtonItem = imageBarButtonItem;
}

- (void)imageBarButtonPressed {
    [self performSegueWithIdentifier:@"FullPhotoVC" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"FullPhotoVC"]) {
        FullCheckInFullPhotoViewController *vc = (FullCheckInFullPhotoViewController *)segue.destinationViewController;
        vc.photo = [[ImageManager sharedInstance] getAvatarImageForUUID:self.person.uuid];
        vc.titleName = self.navigationItem.title;
    }
}

- (void)checkInGirl {
    
    [((SideMenuModel *)[SideMenuModel sharedInstance]).slidingViewController resetTopViewAnimated:NO];
    [((SideMenuModel *)[SideMenuModel sharedInstance]).sideMenuVC performSegueWithID:@"MyGirlNavigationControllerSegue"];
    
}

#pragma mark - FullCheckInGalleryDelegate
- (void)avatarWasChanged {
    [self makeRightBarButton];
}

- (IBAction)checkInAction:(id)sender {
    if ([self.currentViewController isKindOfClass:[FullCheckInGeneralVC class]]) {
        [(FullCheckInGeneralVC *)self.currentViewController savePerson];
    } else if ([self.currentViewController isKindOfClass:[FullCheckInGalleryVC class]]) {
        
    } else if ([self.currentViewController isKindOfClass:[FullCheckInSpecialsVC class]]) {
        [(FullCheckInSpecialsVC *)self.currentViewController savePerson];
    }
    
    if ([self isEnteredDataValid]) {
        NSError *error = nil;
        
        NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
        NSPredicate *uuidPredicate = [NSPredicate predicateWithFormat:@"SELF.uuid == %@",self.person.uuid];
        [lFetchRequest setPredicate:uuidPredicate];
        PersonEntity *personEntity = [[[[CoreDataManager instance] managedObjectContext] executeFetchRequest:lFetchRequest error:&error] lastObject];
        
        personEntity = [MTLManagedObjectAdapter managedObjectFromModel:self.person insertingIntoContext:[[CoreDataManager instance] managedObjectContext] error:&error];
        [[CoreDataManager instance] saveContext];
        
        if ([[SyncManager sharedInstance] connected]) {
            [[self.addGirlServices uploadPersons] subscribeCompleted:^(void) {
                
            }];
        } else {
            [SyncManager sharedInstance].checkForPersonsUploading = YES;
            
        }
    }
    
    if (self.isEditMode) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self checkInGirl];
    }
    
}

@end
