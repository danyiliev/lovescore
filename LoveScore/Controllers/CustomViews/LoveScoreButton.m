//
//  LoveScoreButton.m
//  LoveScore
//
//  Created by Taras Pasichnyk on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "LoveScoreButton.h"
#import "UIColor+ColorAdditions.h"

@implementation LoveScoreButton


- (void)drawRect:(CGRect)rect {
    self.frame = rect;
    
    // Center the text vertically and horizontally
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor redLoveScoreColor].CGColor;
    
    [self setBackgroundColor:[UIColor redLoveScoreColor]];
    
    // Set the font properties
    //  [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
}

@end
