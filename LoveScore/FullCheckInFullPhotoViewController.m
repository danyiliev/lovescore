//
//  FullCheckingFullPhotoViewController.m
//  LoveScore
//
//  Created by Vasyl Khmil on 11/13/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FullCheckInFullPhotoViewController.h"
#import "Global.h"
#import "UINavigationItem+CustomBackButton.h"

@interface FullCheckInFullPhotoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation FullCheckInFullPhotoViewController

#pragma mark - constants

static NSString* const NavigationBarTitleText = @"";

#pragma mark - View Controller life cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    

    [self.photoImageView setImage:self.photo];
    
//    self.navigationItem.title = NavigationBarTitleText;
    
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
}


#pragma mark - Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Public
- (void)setTitleName:(NSString *)titleName {
    self.navigationItem.title = titleName;
}

@end
