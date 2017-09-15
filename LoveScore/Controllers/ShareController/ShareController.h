//
//  ShareController.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/18/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Person.h"


@interface ShareController : NSObject

+ (instancetype)sharedInstance;
- (void)presentShareControllerInViewController:(UIViewController *)viewController withPerson:(Person *)person;
- (void)presentShareControllerInViewController:(UIViewController *)viewController;

@end
