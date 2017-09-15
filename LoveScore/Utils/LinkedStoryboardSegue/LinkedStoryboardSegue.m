//
//  LinkedStoryboardSegue.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/9/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "LinkedStoryboardSegue.h"
#import "UIViewController+ECSlidingViewController.h"

@interface LinkedStoryboardSegue ()
/** Used internally by ECSlidingViewController */
@property (nonatomic, assign) BOOL isUnwinding;

@end

@implementation LinkedStoryboardSegue

+ (UIViewController *)sceneNamed:(NSString *)identifier {
    NSArray *info = [identifier componentsSeparatedByString:@"@"];
    
    NSString *storyboard_name = info[1];
    NSString *scene_name = info[0];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboard_name
                                                         bundle:nil];
    //    TyphoonStoryboard *storyboard = [TyphoonStoryboard storyboardWithName:storyboard_name factory:placeholderVC.assembly bundle:nil];
    UIViewController *scene = nil;
    
    if (scene_name.length == 0) {
        scene = [storyboard instantiateInitialViewController];
    }
    else {
        scene = [storyboard instantiateViewControllerWithIdentifier:scene_name];
    }
    
    return scene;
}

- (id)initWithIdentifier:(NSString *)identifier
                  source:(UIViewController *)source
             destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier
                              source:source
                         destination:[LinkedStoryboardSegue sceneNamed:identifier ]];
    if (self) {
        self.isUnwinding = NO;
        self.skipSettingTopViewController = NO;
    }
    return self;
}

/*- (void)perform
 {
 UIViewController *source = (UIViewController *)self.sourceViewController;
 [source.navigationController pushViewController:self.destinationViewController
 animated:YES];
 }*/

- (void)perform {
    ECSlidingViewController *slidingViewController = [[self sourceViewController] slidingViewController];
    UIViewController *destinationViewController    = [self destinationViewController];
    
    if (self.isUnwinding) {
        if ([slidingViewController.underLeftViewController isMemberOfClass:[destinationViewController class]]) {
            [slidingViewController anchorTopViewToRightAnimated:YES];
        } else if ([slidingViewController.underRightViewController isMemberOfClass:[destinationViewController class]]) {
            [slidingViewController anchorTopViewToLeftAnimated:YES];
        }
    } else {
        if (!self.skipSettingTopViewController) {
            slidingViewController.topViewController = destinationViewController;
        }
        
        [slidingViewController resetTopViewAnimated:YES];
    }
}

@end
