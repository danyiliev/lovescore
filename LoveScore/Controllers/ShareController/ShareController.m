//
//  ShareController.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/18/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ShareController.h"
#import "Global.h"
#import "SendToVC.h"
#import "SharingServices.h"

@interface ShareController ()

@property (nonatomic, strong) Person *person;

@end

@implementation ShareController {
    SendToVC *_viewController;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


- (void)presentShareControllerInViewController:(UIViewController *)viewController withPerson:(Person *)person {
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil                                                                            message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    alertController.view.tintColor = RED_COLOR;
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel");
                                   }];
    
    UIAlertAction *shareTeaserCardAction = [UIAlertAction
                                            actionWithTitle:@"Share Teaser Card"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action)
                                            {
                                                _viewController = (SendToVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"SendToVC");
                                                
                                                _viewController.person = person;
                                                _viewController.isTeaserCard = YES;
                                                _viewController.isFullCard = NO;
                                                
                                                [viewController.navigationController pushViewController:_viewController animated:YES];
                                            }];
    
    UIAlertAction *shareFullCarAction = [UIAlertAction
                                         actionWithTitle:@"Share Full Card"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action)
                                         {
                                             _viewController = (SendToVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"SendToVC");
                                             _viewController.person = person;
                                             _viewController.isTeaserCard = NO;
                                             _viewController.isFullCard = YES;
                                             
                                             [viewController.navigationController pushViewController:_viewController animated:YES];
                                         }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:shareTeaserCardAction];
    [alertController addAction:shareFullCarAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)presentShareControllerInViewController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil                                                                            message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    alertController.view.tintColor = RED_COLOR;
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel");
                                   }];
    
    UIAlertAction *shareTeaserCardAction = [UIAlertAction
                                            actionWithTitle:@"Share Teaser Card"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action)
                                            {
                                                _viewController = (SendToVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"SendToVC");
                                                _viewController.isTeaserCard = YES;
                                                _viewController.isFullCard = NO;
                                                
                                                [viewController.navigationController pushViewController:_viewController animated:YES];
                                            }];
    
    UIAlertAction *shareFullCarAction = [UIAlertAction
                                         actionWithTitle:@"Share Full Card"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action)
                                         {
                                             _viewController = (SendToVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"SendToVC");
                                             _viewController.isTeaserCard = NO;
                                             _viewController.isFullCard = YES;
                                             
                                             [viewController.navigationController pushViewController:_viewController animated:YES];
                                         }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:shareTeaserCardAction];
    [alertController addAction:shareFullCarAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}


@end
