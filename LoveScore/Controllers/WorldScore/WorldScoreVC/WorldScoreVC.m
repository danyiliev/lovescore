//
//  WorldScoreVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//
#import "WorldScoreProtocol.h"
#import "WorldScoreVC.h"
#import "SideMenuModel.h"
#import "TTTAttributedLabel + ColorText.h"
#import "FSInteractiveMapView.h"
#import "MapWorldScoreVC.h"

@interface WorldScoreVC () 

@property (nonatomic, weak)  UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation WorldScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapWorldScoreId"];
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"WORLD SCORE" withRedWord:@"SCORE"];
    [[SideMenuModel sharedInstance] addEdgeSwipeOnView:self.view];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)callSideMenu:(UIBarButtonItem *)sender {
    [[SideMenuModel sharedInstance] anchorRight];
}

#pragma mark - Private

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    
    [parentView addConstraints:constraints];
}

- (IBAction)segmentedControlValueChanged:(id)sender {
    UISegmentedControl *segmentedControl = sender;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticsWorldScoreId"];
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
    
    if (segmentedControl.selectedSegmentIndex == 1) {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapWorldScoreId"];
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
    if (segmentedControl.selectedSegmentIndex == 2) {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCountryWorldScoreId"];
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
}

- (void)cycleFromViewController:(UIViewController *) oldViewController
               toViewController:(UIViewController *) newViewController {
    
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    [newViewController.view layoutIfNeeded];
    
    // set starting state of the transition
    newViewController.view.alpha = 0;
    
    [UIView animateWithDuration:0
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         
                         [newViewController didMoveToParentViewController:self];
                     }];
}

@end
