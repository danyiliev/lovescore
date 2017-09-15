//
//  SaveNewPasswordVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/18/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "SaveNewPasswordVC.h"
#import "NavigationTitle.h"
#import "UINavigationItem+CustomBackButton.h"
#import "TTTAttributedLabel + ColorText.h"

#import "UserServices.h"

@interface SaveNewPasswordVC () <UserServicesDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstTextField;
@property (strong, nonatomic) IBOutlet UITextField *secondTextField;


@end

@implementation SaveNewPasswordVC

- (void)viewDidLoad {
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"CHANGE PASSWORD" withRedWord:@"PASSWORD"];
}

- (IBAction)saveButtonAction:(UIBarButtonItem *)sender {
    
    UserServices *userServices = [UserServices new];
    
    userServices.delegate = self;
    
    if ([[SyncManager sharedInstance] connected]) {
        
        if ([self.firstTextField.text isEqualToString:self.secondTextField.text]) {
            [[userServices updateUserDetailsWithField:@"password" value:self.firstTextField.text] subscribeError:^(NSError *error) {
                [self showErrorMessage:@"Wrong format."];
                
            }   completed:^(void) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        } else {
            [self showErrorMessage:@"Password does not match the confirm password."];
        }
    } else {
        [self showErrorMessage:@"Check your internet connection."];
    }
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private methods

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
