//
//  NewPasscodeVC.m
//  LoveScore
//
//  Created by Taras Pasichnyk on 10/21/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "NewPasscodeVC.h"

@interface NewPasscodeVC ()

@end

@implementation NewPasscodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.passcodeTextField.formatter setDefaultOutputPattern:@"#  #  #  #"];
    
    [self registerForKeyboardNotifications];
}


-(void)viewWillAppear:(BOOL)animated {
    [self.passcodeTextField becomeFirstResponder];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    float tabbarHeight = 100.0f;
    CGRect messageFrame = self.view.frame;
    messageFrame.origin.y -= keyboardSize.height - tabbarHeight;
    [self.view setFrame:messageFrame];
    
    [UIView commitAnimations];
}


- (void)keyboardWillDisappear:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    
    float tabbarHeight = 100.0f;
    CGRect messageFrame = self.passcodeTextField.frame;
    messageFrame.origin.y += keyboardSize.height - tabbarHeight;
    [self.passcodeTextField setFrame:messageFrame];
    [UIView commitAnimations];
}
@end
