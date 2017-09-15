//
//  FullCardSlider.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FullCardSlider.h"

@interface FullCardSlider ()

@end

@implementation FullCardSlider

- (void)drawRect:(CGRect)rect {
    
    [self setThumbImage:[UIImage imageNamed:@"slider_config_heart"] forState:UIControlStateNormal];
}

#pragma mark - override custom methods to change appearance

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {

    CGRect finalBounds = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    return CGRectMake(finalBounds.origin.x,finalBounds.origin.y *2/3, finalBounds.size.width / 2, finalBounds.size.height / 2);
}


@end
