//
//  KeyboardHandlingMechanism.h
//  Caravan
//
//  Created by Roman Sakhnievych on 2/26/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KeyboardHandlingMechanism : NSObject

- (void)registerForKeyboardNotificationWithController:(UIViewController *)viewController
                                           scrollView:(UIScrollView *)scrollView
                                     bottomConstraint:(NSLayoutConstraint *)bottomConstraint;

- (void)addActiveTextField:(UITextField *)textField;
- (void)addActiveTextView:(UITextView *)textView;
- (void)unregisterFromKeyboardNotifications;

@end
