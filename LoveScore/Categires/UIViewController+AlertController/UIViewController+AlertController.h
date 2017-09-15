//
//  UIViewController+AlertController.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/21/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AlertController)

- (void)showAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)message;
- (void)showAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)message withCompletion:(void (^)())completion;

- (void)showAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)message andWithActions:(NSArray *)actionsArray;

- (BOOL)checkInternet;

@end
