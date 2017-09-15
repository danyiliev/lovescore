//
//  RoundDoubleRateView.m
//  LoveScore
//
//  Created by Marcin Podeszwa on 7/5/17.
//  Copyright © 2017 KindGeek. All rights reserved.
//

#import "RoundDoubleRateView.h"

@interface RoundDoubleRateView  ()

@property (strong, nonatomic) UILabel *value1Label;
@property (strong, nonatomic) UILabel *value2Label;
@property (strong, nonatomic) UILabel *dividerLabel;

@end

@implementation RoundDoubleRateView

- (instancetype)init {
    if (self = [super init]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.backgroundColor = [UIColor clearColor];
    _dividerLabel = [UILabel new];
    _dividerLabel.textAlignment = NSTextAlignmentCenter;
    _dividerLabel.text = @"/";
    _value1Label = [UILabel new];
    _value1Label.textAlignment = NSTextAlignmentCenter;
    _value2Label = [UILabel new];
    _value2Label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dividerLabel];
    [self addSubview:_value1Label];
    [self addSubview:_value2Label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.layer setCornerRadius:self.frame.size.width / 2];
    self.clipsToBounds = true;

    CGRect frame = self.bounds;
    frame.size.height = frame.size.height - (frame.size.height / 16.0);

    _dividerLabel.frame = frame;

    CGFloat xOffset = 2;
    frame.size.width /= 2;
    frame.size.width -= xOffset;
    frame.origin.x = xOffset;
    CGFloat yOffset = frame.size.height / 8.0;
    frame.size.height -= yOffset;
    _value1Label.frame = frame;

    frame.origin.x = self.bounds.size.width / 2.0;
    frame.origin.y = yOffset;
    _value2Label.frame = frame;
}

- (void)setFontName:(NSString *)fontFamily size:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:fontFamily size:size];
    _dividerLabel.font = font;
    _value1Label.font = font;
    _value2Label.font = font;
}

- (void)setValueWithString1:(NSString *)value1 string2:(NSString *)value2 {
    _value1Label.text = value1;
    _value2Label.text = value2;
}

@end
