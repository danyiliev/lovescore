//
//  ActionButton.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/7/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionButton : UIButton

@property (assign, nonatomic)BOOL isChecked;

- (void)checkWithImageName:(NSString *)name;
- (void)uncheckWithImageName:(NSString *)name;

@end
