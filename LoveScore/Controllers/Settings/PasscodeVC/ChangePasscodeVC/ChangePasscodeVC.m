//
//  ChangePasscodeVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/10/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "ChangePasscodeVC.h"
#import "SHSPhoneTextField.h"
#import "NewPasscodeVC.h"
#import <SSKeychain/SSKeychainQuery.h>
#import <SSKeychain/SSKeychain.h>

@interface ChangePasscodeVC ()

@property (strong, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (strong, nonatomic) NSString *currentPassword;

@end

@implementation ChangePasscodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPassword = @"";
    
    [self.passcodeTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    
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

-(void)viewWillAppear:(BOOL)animated {
    [self.passcodeTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonAction:(UIBarButtonItem *)sender {
    NSString *passcode = [SSKeychain passwordForService:@"lovescore" account:self.username];
    
    if ([self.currentPassword isEqualToString:passcode]) {
        [self.view endEditing:YES];
        [self performSegueWithIdentifier:@"changePasscodeSegueIdentifier2" sender:self];
    } else {
        self.passcodeTextField.text = @"";
        self.currentPassword = @"";
        
        [self showAlertControllerWithTitle:@"Warning!" withMessage:@"You enter wrong passcode."];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)screenTapped{
    [self.view endEditing:YES];
}
#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"changePasscodeSegueIdentifier2"]) {
        NewPasscodeVC *vc = segue.destinationViewController;
        vc.username = self.username;
    }
}

@end
