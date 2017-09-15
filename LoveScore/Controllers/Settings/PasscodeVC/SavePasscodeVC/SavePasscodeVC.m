//
//  ChangePasscodeVC.m
//  LoveScore
//
//  Created by Taras Pasichnyk on 10/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SavePasscodeVC.h"
#import "NavigationTitle.h"
#import "Global.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"
#import "SHSPhoneLibrary.h"

#import <SSKeychain/SSKeychainQuery.h>
#import <SSKeychain/SSKeychain.h>

@interface SavePasscodeVC ()

- (IBAction)saveBarButtonPressed:(id)sender;
- (IBAction)screenTapped;

@property (nonatomic, strong) NSString *secondPasscode;

@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (strong, nonatomic) NSString *currentPassword;

@end

@implementation SavePasscodeVC

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"PASSCODE" withRedWord:@"CODE"];

    self.currentPassword = @"";
    [self.passcodeTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.passcodeTextField becomeFirstResponder];
}

#pragma mark - IBActions

- (IBAction)saveBarButtonPressed:(id)sender {
    
    if ([self.currentPassword isEqualToString:self.firstPasscode]) {
        
        [SSKeychain setPassword:self.firstPasscode forService:@"lovescore" account:self.username];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self showAlertControllerWithTitle:@"Warning!" withMessage:@"First and second passcodes are different"];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSString * password = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (password.length < self.currentPassword.length) {
        
        if (self.currentPassword.length == 4) {
            
            self.currentPassword = [self.currentPassword substringToIndex:self.currentPassword.length - 1];
            return;
        }
    }
    
    if ([[textField.text substringFromIndex:textField.text.length - 1] isEqualToString:@" "]) {
        
        self.currentPassword = [self.currentPassword substringToIndex:self.currentPassword.length - 1];
        
        if (textField.text.length > 2) {
            
            textField.text = [textField.text substringToIndex:textField.text.length - 2];
        } else {
            
            textField.text = @"";
            self.currentPassword = @"";
        }
        return;
    } else {
        self.currentPassword = [self.currentPassword stringByAppendingString:[textField.text substringFromIndex:textField.text.length-1]];
    }

    NSString * strippedNumber = textField.text;
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"1" withString:@"•"];
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"2" withString:@"•"];
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"3" withString:@"•"];
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"4" withString:@"•"];
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"5" withString:@"•"];
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"6" withString:@"•"];
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"7" withString:@"•"];
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"8" withString:@"•"];
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"9" withString:@"•"];
    strippedNumber = [strippedNumber stringByReplacingOccurrencesOfString:@"0" withString:@"•"];
    
    self.passcodeTextField.text = strippedNumber;
    
    if (self.currentPassword.length != 4) {
        self.passcodeTextField.text = [self.passcodeTextField.text stringByAppendingString:@"  "];
    }
    
    if (password.length > 4) {
        self.passcodeTextField.text = @"";
        self.currentPassword = @"";
    }
}

- (IBAction)screenTapped{
    [self.view endEditing:YES];
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
