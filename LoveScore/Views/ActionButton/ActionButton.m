//
//  ActionButton.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/7/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ActionButton.h"
#import "Global.h"

@implementation ActionButton 

- (void)checkWithImageName:(NSString *)name {
    self.isChecked = YES;
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self setBackgroundColor:RED_COLOR];
}

- (void)uncheckWithImageName:(NSString *)name {
    self.isChecked = NO;
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:247.0/255.0f blue:247.0/255.0f alpha:1]];
}

@end
