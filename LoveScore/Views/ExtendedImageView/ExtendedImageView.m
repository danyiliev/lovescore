//
//  ExtendedImageView.m
//  LoveScore
//
//  Created by Timur Umayev on 4/27/16.
//  Copyright © 2016 Rarefields. All rights reserved.
//

#import "ExtendedImageView.h"

@implementation ExtendedImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.layer setCornerRadius:self.frame.size.width * 0.5];
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
