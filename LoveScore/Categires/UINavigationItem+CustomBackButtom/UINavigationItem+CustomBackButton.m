//
//  UINavigationItem+CustomBackButton.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/27/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "UINavigationItem+CustomBackButton.h"

@implementation UINavigationItem(CustomBackButton)

+ (void)makeLeftArrowBarButtonInNavigationItem:(UIViewController *)viewController selector:(SEL)selector {
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"BackArrow"];
    
    CGRect frameimg = CGRectMake(0,0,backButtonImage.size.height,backButtonImage.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frameimg];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(-6, -6, 0, 0)];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton.imageView setContentMode:UIViewContentModeCenter];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:viewController action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    viewController.navigationItem.leftBarButtonItem = backBarButton;
}


@end
