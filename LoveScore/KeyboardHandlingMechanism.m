//
//  KeyboardHandlingMechanism.m
//  Caravan
//
//  Created by Roman Sakhnievych on 2/26/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "KeyboardHandlingMechanism.h"

static const CGFloat keyboardBottomConstraintDefaulValue = 0;
static const CGFloat animationDuration = 0.2;

@interface KeyboardHandlingMechanism ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraintForKeyboard;
@property (strong, nonatomic) UITextView *activeTextView;
@property (strong, nonatomic) UITextField *activeTextField;

@end

@implementation KeyboardHandlingMechanism

#pragma mark - Public methods

- (void)registerForKeyboardNotificationWithController:(UIViewController *)viewController
                                           scrollView:(UIScrollView *)scrollView
                                     bottomConstraint:(NSLayoutConstraint *)bottomConstraint {
    self.viewController = viewController;
    self.scrollView = scrollView;
    self.bottomConstraintForKeyboard = bottomConstraint;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addActiveTextField:(UITextField *)textField {
    self.activeTextField = textField;
}

- (void)addActiveTextView:(UITextView *)textView {
    self.activeTextView = textView;
}

- (void)unregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat height = keyboardSize.size.height;
    UIEdgeInsets contentInset = UIEdgeInsetsMake(0.0, 0.0, height, 0.0);
    self.scrollView.contentInset = contentInset;
    self.scrollView.scrollIndicatorInsets = contentInset;
    CGRect rect = self.viewController.view.frame;
    rect.size.height -= keyboardSize.size.height;
    if (self.activeTextField) {
        if (CGRectContainsPoint(rect, self.activeTextField.frame.origin) == NO) {
            [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:YES];
        }
    } else if (self.activeTextView) {
        if (CGRectContainsPoint(rect, self.activeTextView.frame.origin) == NO) {
            [self.scrollView scrollRectToVisible:self.activeTextView.frame animated:YES];
        }
    }
    [self adjustKeyboardFrame:info];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)adjustKeyboardFrame:(id)userInfo {
    if (self.activeTextField || self.activeTextView) {
        CGSize size = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        self.bottomConstraintForKeyboard.constant = size.height + keyboardBottomConstraintDefaulValue;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    [self.viewController.view layoutIfNeeded];
    self.bottomConstraintForKeyboard.constant = keyboardBottomConstraintDefaulValue;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.viewController.view layoutIfNeeded];
    }];
    
}

@end
