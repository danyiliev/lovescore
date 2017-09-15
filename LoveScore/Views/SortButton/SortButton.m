//
//  SortButton.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SortButton.h"
 
@implementation SortButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setImage:[UIImage imageNamed:@"sort-icon"] forState:UIControlStateNormal];
    [self setTitle:@"Rating" forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(self.frame.size.width - 8 - self.imageView.frame.size.width, self.frame.size.height / 2 - self.imageView.frame.size.height / 2, self.imageView.frame.size.width, self.imageView.frame.size.height)];

    [self.titleLabel setFrame:CGRectMake(self.frame.size.width - 8 - self.imageView.frame.size.width - self.titleLabel.frame.size.width - 8 , 0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height)];
}
@end
