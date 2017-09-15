//
//  PassCodeVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/11/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "PassCodeVC.h"
#import "UIColor+ColorAdditions.h"
#import "UIImage+ImageAdditions.h"
#import "SHSPhoneTextField.h"
#import "AppDelegate.h"
#import <SSKeychain/SSKeychainQuery.h>
#import <SSKeychain/SSKeychain.h>

#import <ReactiveCocoa/RACEXTScope.h>

#import <AudioToolbox/AudioServices.h>

@interface PassCodeVC ()


@property (strong, nonatomic) IBOutlet UITextField *passcodeTextField;

@property (strong, nonatomic) NSString *currentPassword;

@end

@implementation PassCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPassword = @"";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithImage:[UIImage imageNamed:@"bg-intro"] scaledToSize:self.view.frame.size]];
    
    [self.passcodeTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if ([[textField.text substringFromIndex:textField.text.length - 1] isEqualToString:@" "]) {
    
        self.currentPassword = [self.currentPassword substringToIndex:self.currentPassword.length - 1];
        if (textField.text.length > 2) {
            textField.text = [textField.text substringToIndex:textField.text.length - 2];
        } else {
            textField.text = @"";
        }
        return;
    } else {
        self.currentPassword = [self.currentPassword stringByAppendingString:[textField.text substringFromIndex:textField.text.length-1]];
    }
    
    NSString * password = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
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

    if (password.length == 4) {
        
        NSString *passcode = [SSKeychain passwordForService:@"lovescore" account:self.username];
        
        if ([self.currentPassword isEqualToString:passcode]) {
            [self.view endEditing:YES];
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            self.passcodeTextField.text = @"";
            self.currentPassword = @"";
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.passcodeTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButtonAction:(id)sender {
    [self.passcodeTextField resignFirstResponder];
    [[SyncManager sharedInstance] logOut];
}

- (IBAction)screenTapped{
    [self.view endEditing:YES];
}

@end
