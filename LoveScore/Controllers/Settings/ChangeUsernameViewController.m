//
//  ChangeUsernameViewController.m
//  LoveScore
//
//  Created by Vasyl Khmil on 11/11/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ChangeUsernameViewController.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"

#import "UserServices.h"
#import "CoreDataManager.h"
#import "UserEntity.h"
#import "SideMenuModel.h"

@interface ChangeUsernameViewController ()


@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation ChangeUsernameViewController

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"CHANGE USERNAME" withRedWord:@"USERNAME"];
    
    if (self.user.username && self.user.username.length > 0) {
        [self.usernameTextField setText:self.user.username];
    }
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions

- (IBAction)saveBarButtonPressed:(id)sender {
    if ([self validateName:self.usernameTextField.text]) {
        
        UserServices *userServices = [UserServices new];
        
        [[userServices updateUserDetailsWithField:@"username" value:self.usernameTextField.text]
         
         subscribeError:^(NSError *error) {
             
             [self showErrorMessage:@"Operation couldn't be done."];
         } completed:^(void) {
             
             if (!self.user.displayName || [self.user.displayName isEqualToString:@""]) {
                 [[SideMenuModel sharedInstance] setName:self.usernameTextField.text];
             }

             self.user.username = self.usernameTextField.text;
             NSError *error = nil;
             
             [MTLManagedObjectAdapter managedObjectFromModel:self.user
                                        insertingIntoContext:[[CoreDataManager instance] managedObjectContext]
                                                       error:&error];
             [[CoreDataManager instance] saveContext];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self dismissViewControllerAnimated:YES completion:nil];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             });
         }
         ];
    }
}

- (IBAction)screenTapped{
    [self.view endEditing:YES];
}


#pragma mark - Public methods

- (void)setUser:(User *)user {
    _user = user;
}
#pragma mark - Private methods

- (BOOL)validateName:(NSString *)name {
    BOOL validationResult = YES;
    
    NSString *errorMessage;
    
    NSUInteger nameLength = name.length;
    
    if (nameLength < 2 || nameLength > 25) {
        validationResult = NO;
        errorMessage = @"Wrong username length";
    }
    
    for (int i = 0; i < nameLength; i++) {
        int character = [name characterAtIndex:i];
        
        if ((character >= 65 && character <= 90) || (character >= 97 && character <= 122) ||
            (character >= 48 && character <= 57) ) {
            
        } else {
            validationResult = NO;
            errorMessage = @"Using wrong symbols";
        }
    }
    
    if (!validationResult) {
        [self showErrorMessage:errorMessage];
    }
    
    return validationResult;
}
- (void)showErrorMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Warning!"
                                          message:message
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
@end
