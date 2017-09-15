//
//  LinkedStoryboardSegue.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/9/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedStoryboardSegue : UIStoryboardSegue

/**
 Determines whether the destination view controller should replace the top view controller. This value can be set by casting a `UIStoryboardSegue` to a `ECSlidingSegue` in your view controller's `prepareForSegue:sender:` method.
 
 If set to `NO`, the top view controller will be replaced with an instance of the segue's destination view controller. If set to `YES`, the top view controller will not be replaced, and the existing top view controller will be used. Setting this to `YES` is useful for caching the top view controller and keeping its current state. The default value is `NO`.
 */
@property (nonatomic, assign) BOOL skipSettingTopViewController;

//+ (UIViewController *)sceneNamed:(NSString *)identifier;

@end
