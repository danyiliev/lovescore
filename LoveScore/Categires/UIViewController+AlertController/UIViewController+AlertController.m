//
//  UIViewController+AlertController.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/21/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "UIViewController+AlertController.h"
#import "SyncManager.h"

@implementation UIViewController (AlertController)

- (void)showAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
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

- (void)showAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)message withCompletion:(void (^)())completion {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *showWarningAction = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction *action)
                                        {
                                            completion();   
                                        }];
    
    [alertController addAction:showWarningAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    alertController.view.tintColor = RED_COLOR;
}

- (void)showAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)message andWithActions:(NSArray *)actionsArray {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    if (actionsArray && actionsArray.count > 0) {
        for (UIAlertAction *action in actionsArray) {
            [alertController addAction:action];
        }
    } else {
        UIAlertAction *showWarningAction = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action)
                                            {
                                            }];
        
        [alertController addAction:showWarningAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    alertController.view.tintColor = RED_COLOR;

}

- (BOOL)checkInternet {
    if ([[SyncManager sharedInstance] connected]) {
        return YES;
    } else {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning!"
                                              message:@"Check your internet connection."
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
        return NO;
    }
}

@end
