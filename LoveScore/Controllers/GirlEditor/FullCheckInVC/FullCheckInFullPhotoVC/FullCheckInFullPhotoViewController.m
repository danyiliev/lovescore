//
//  FullCheckingFullPhotoViewController.m
//  LoveScore
//
//  Created by Vasyl Khmil on 11/13/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FullCheckInFullPhotoViewController.h"
#import "Global.h"


@implementation FullCheckInFullPhotoViewController

#pragma mark - constants

static NSString* const NavigationBarTitleText = @"KATARINA HOLIWOOD";

#pragma mark - View Controller life cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = NavigationBarTitleText;
    [self makeLeftArrowBarButton];
}


#pragma mark - Bar Buttons Actions

- (void)makeLeftArrowBarButton{
    UIImage *backButtonImage = [UIImage imageNamed:@"BackArrow"];
    
    CGRect frameimg = CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frameimg];
    [backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
}

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
