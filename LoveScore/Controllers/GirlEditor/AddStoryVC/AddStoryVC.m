//
//  AddStoryVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "AddStoryVC.h"
#import "WYPopoverController.h"
#import "ExtendedButton.h"
#import "AddStoryContentPopoverVC.h"


@interface AddStoryVC () <WYPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet ExtendedButton *addStoryButton;
@property (strong, nonatomic) WYPopoverController *popoverController;


@end

@implementation AddStoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

    [WYPopoverController setDefaultTheme:[WYPopoverTheme theme]];
    
    WYPopoverBackgroundView *appearance = [WYPopoverBackgroundView appearance];
    [appearance setTintColor:[UIColor orangeColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addStoryButtonAction:(UIButton *)sender {
    AddStoryContentPopoverVC *controller = [AddStoryContentPopoverVC new];
    
    _popoverController = [[WYPopoverController alloc] initWithContentViewController:controller];
    _popoverController.delegate = self;
    [_popoverController presentPopoverFromRect:_addStoryButton.bounds inView:_addStoryButton permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    
    [_popoverController setPopoverContentSize:CGSizeMake(280, 275)];
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller {
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller {
    _popoverController.delegate = nil;
    _popoverController = nil;
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController {
    return YES;
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/
@end
