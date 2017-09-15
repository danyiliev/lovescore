//
//  ProgressView.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/27/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()

@property (nonatomic, strong) UILabel *secondLabel;

@end

@implementation ProgressView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _progress = [UIView new];
    _lable = [UILabel new];
    _progress.frame = CGRectMake(0, 0, 0, self.frame.size.height);

    self.secondLabel = [UILabel new];
    [self.secondLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:13]];
    [self.secondLabel setTextColor:[UIColor whiteColor]];
    self.secondLabel.text = @"74%";

    [_lable setFont:[UIFont fontWithName:@"Lato-Regular" size:13]];
    [_lable setTextColor:[UIColor blackColor]];
    [_progress setBackgroundColor:RED_COLOR];
    _lable.text = @"74%";
    

    [self addSubview:_lable];
    [self addSubview:_progress];

    [_progress addSubview:self.secondLabel];
    
    [_progress setClipsToBounds:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _progressValue = (self.frame.size.width * _percents) / 100;
    
    _progress.frame = CGRectMake(0, 0, _progressValue, self.frame.size.height);
    CGFloat lableWidth = 36.0f;
    CGFloat lableHeght = 16.0f;
    CGFloat lableX = (self.frame.size.width / 2) - (lableWidth / 2);
    CGFloat lableY = (self.frame.size.height / 2) - (lableHeght /2);
    _lable.frame = CGRectMake(lableX,lableY,lableWidth,lableHeght);
    self.secondLabel.frame = CGRectMake(lableX,lableY,lableWidth,lableHeght);
}

- (void)setProgressWithPercent:(NSInteger)percents {
    _percents = percents;
    
    _lable.text = [NSString stringWithFormat:@"%li%%",(long)percents];
    self.secondLabel.text = [NSString stringWithFormat:@"%li%%",(long)percents];

    [self layoutSubviews];
}

@end
