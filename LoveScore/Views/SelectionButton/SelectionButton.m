//
//  SelectionButton.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SelectionButton.h"

@implementation SelectionButton

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor colorWithRed:237.0 / 255.0f green:237.0 / 255.0f blue:237.0 / 255.0f alpha:1]];
    [self setTitleColor:[UIColor colorWithRed:52.0 / 255.0f green:52.0 / 255.0f blue:52.0 / 255.0f alpha:1] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"sort-icon"] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width - 17, 0, 0)];
}

- (void)setTitleOffset:(CGFloat)offset {
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
}

@end
