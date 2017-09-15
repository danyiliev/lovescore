//
//  SideMenuModel.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SideMenuVC.h"
#import "ECSlidingViewController.h"


@protocol SideMenuModelDeleagate <NSObject>

- (void)addEdgeSwipeOnView:(UIView *)view;
- (void)removeEdgeSwipeFromView:(UIView *)view;


@end

@interface SideMenuModel : NSObject

@property (nonatomic, strong) SideMenuVC *sideMenuVC;

@property (nonatomic, strong) ECSlidingViewController *slidingViewController;


+ (void)resetSharedInstance;

+ (id)sharedInstance;
- (void)anchorRight;
- (void)changeSideMenuState;

- (void)setAvatar:(UIImage *)image;
- (void)setName:(NSString *)name;

- (void)reset;

- (void)performSegueWithID:(NSString *)identifier withSender:(id)sender;


@end
