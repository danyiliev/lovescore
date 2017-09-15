//
//  SideMenuCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/12/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SideMenuCell.h"

@interface SideMenuCell () {
    
}

@property (nonatomic, strong) UIView *separator;

@end

@implementation SideMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separator = [[UIView alloc] initWithFrame:CGRectMake(36, self.frame.size.height - 2, self.frame.size.width, 0.5f)];
    [self.separator setBackgroundColor:[UIColor colorWithRed:52.f / 255.f green:52.f / 255.f blue:52.f / 255.f alpha:1.f]];
    [self addSubview:self.separator];
    
}

- (void)layoutSubviews {
    
    [self.separator setFrame: CGRectMake(36, self.frame.size.height - 2, self.frame.size.width, 0.5f)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
}

- (void)removeSeparator {
    [self.separator removeFromSuperview];
}
@end
