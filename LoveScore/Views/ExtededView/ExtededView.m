//
//  ExtededView.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/29/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ExtededView.h"

@implementation ExtededView

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self.layer setCornerRadius:cornerRadius];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self.layer setBorderWidth:borderWidth];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self.layer setBorderColor:[borderColor CGColor]];
}

@end
