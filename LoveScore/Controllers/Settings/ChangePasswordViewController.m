//
//  ChangePasswordViewController.m
//  LoveScore
//
//  Created by Vasyl Khmil on 11/10/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ResetPasswordVC.h"
#import "NavigationTitle.h"
#import "Global.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"

#import "UserServices.h"

@interface ChangePasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)forgotYourPasswordButtonPressed:(id)sender;

@end

@implementation ChangePasswordViewController

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"CHANGE PASSWORD" withRedWord:@"PASSWORD"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - IBActions

- (IBAction)forgotYourPasswordButtonPressed:(id)sender {
    
//    [self performSegueWithIdentifier:@"changePasswordSegueIdentifier" sender:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIViewController *viewController = VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Login", @"ResetPasswordVC");
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)nextButtonAction:(UIBarButtonItem *)sender {
    
    UserServices *userServices = [UserServices new];
    
    if ([[SyncManager sharedInstance] connected]) {
        
        [[userServices loginWithUsername:self.username password:self.passwordTextField.text] subscribeError:^(NSError *error) {
            [self showErrorMessage:@"Wrong password."];
            
        }   completed:^(void) {
            [self performSegueWithIdentifier:@"changePasswordSegueIdentifier2" sender:self];
        }];
        
    } else {
        
        [self showErrorMessage:@"Check your internet connection."];
    }
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


#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
