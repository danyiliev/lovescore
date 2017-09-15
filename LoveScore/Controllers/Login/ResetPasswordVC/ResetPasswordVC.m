//
//  ResetPasswordVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ResetPasswordVC.h"
#import "UIColor+ColorAdditions.h"
#import "UIImage+ImageAdditions.h"
#import "TTTAttributedLabel.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "UserServices.h"

@interface ResetPasswordVC ()<UserServicesDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *logoLabel;
- (IBAction)goBackTap:(id)sender;

@property (nonatomic, strong) UserServices *userServices;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation ResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userServices = [UserServices new];
    
    
    self.logoLabel.numberOfLines = 0;
    
    NSString *lString = self.logoLabel.text;
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.logoLabel setText:lString afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange redRange = [lString rangeOfString:@"Love"];
        if (redRange.location != NSNotFound) {
            
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RED_COLOR.CGColor range:redRange];
        }
        
        return mutableAttributedString;
    }];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithImage:[UIImage imageNamed:@"bg-intro"] scaledToSize:self.view.frame.size]];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.usernameTextField setDelegate:self];
    [self.usernameTextField setReturnKeyType:UIReturnKeyDone];
    [self.usernameTextField addTarget:self
                            action:@selector(dismissKeyboard)
                  forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - User Services delegate

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

#pragma mark - UITextFieldDelegate

- (void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
}

#pragma mark - Keyboard

- (void)keyboardWillShow {
    [self setViewMovedUp:YES];
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
}

-(void)keyboardWillHide {
    [self setViewMovedUp:NO];
    
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)sender {
    
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp {
    
    if ([UIScreen mainScreen].bounds.size.width <= 320) {
        if (movedUp){
            self.heightConstraint.constant = 0;
        } else {
            self.heightConstraint.constant = 66.f;
        }
        
        [UIView animateWithDuration:8.f
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
    }
}

- (IBAction)resetPasswordAction:(id)sender {
    
    if ([[SyncManager sharedInstance] connected]) {
        
        [[self.userServices getNewPasswordForUserWithUsername:self.usernameTextField.text] subscribeError:^(NSError *error) {
            
            [self showErrorMessage:@"Something goes wrong"];
        }   completed:^(void) {
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Success!"
                                                  message:@"Password was sent on your email"
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
        }];
        
    } else {
        [self showErrorMessage:@"Check your internet connection"];
    }
}

- (IBAction)goBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
