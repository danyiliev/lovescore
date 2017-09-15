//
//  NewPasscodeVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/10/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "NewPasscodeVC.h"
#import "SHSPhoneTextField.h"
#import "SavePasscodeVC.h"
#import "TTTAttributedLabel + ColorText.h"

@interface NewPasscodeVC ()

@property (strong, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (strong, nonatomic) NSString *currentPassword;

@end

@implementation NewPasscodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"PASSCODE" withRedWord:@"CODE"];
    
    [self.passcodeTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.passcodeTextField becomeFirstResponder];
    self.currentPassword = @"";
    self.passcodeTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)nextButtonAction:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"repeatPasscodeSegueIdentifier" sender:self];
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)screenTapped{
    [self.view endEditing:YES];
}

#pragma mark - UITextField actions

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

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"repeatPasscodeSegueIdentifier"]) {
        SavePasscodeVC *vc = segue.destinationViewController;
        vc.firstPasscode = self.currentPassword;
        vc.username = self.username;
    }
}

@end
