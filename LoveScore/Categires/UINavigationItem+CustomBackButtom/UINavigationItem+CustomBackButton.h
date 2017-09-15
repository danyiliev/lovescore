//
//  UINavigationItem+CustomBackButton.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/27/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem(CustomBackButton)

+ (void)makeLeftArrowBarButtonInNavigationItem:(UIViewController *)viewController selector:(SEL)selector;

@end
