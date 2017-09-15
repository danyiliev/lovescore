//
//  WipeAccountViewController.m
//  LoveScore
//
//  Created by Vasyl Khmil on 11/11/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "WipeAccountViewController.h"
#import "Global.h"
#import "NavigationTitle.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"
#import "UserServices.h"

@interface WipeAccountViewController ()
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end


@implementation WipeAccountViewController

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.secureTextEntry = YES;

    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"WIPE ACCOUNT" withRedWord:@"ACCOUNT"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}
#pragma mark - IBActions

//- (IBAction)finishBarButtonPressed:(id)sender {

//      BIND TO MYGIRLS SCREEN
    
//    [self dismissViewControllerAnimated:YES completion:nil];
//UIViewController *viewController = VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Login", @"ResetPasswordVC");
//[self.navigationController pushViewController:viewController animated:YES];


- (IBAction)forgotYourPasswordButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIViewController *viewController = VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Login", @"ResetPasswordVC");
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)screenTapped{
    [self.view endEditing:YES];
}

- (IBAction)nexButtonAction:(id)sender {
    
    if ([[SyncManager sharedInstance] connected]) {
        UserServices *userServices = [UserServices new];
        
        [[userServices loginWithUsername:self.username password:self.passwordTextField.text] subscribeError:^(NSError *error) {
            
            [self showErrorMessage:@"Check password."];
            
        }   completed:^(void) {
            [self performSegueWithIdentifier:@"wipe2SegueIdentifier" sender:self];
        }];
    } else {
        [self showErrorMessage:@"Check internet connetion."];
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
