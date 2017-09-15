//
//  RoundRateView.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/27/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "RoundRateView.h"

@interface RoundRateView  ()

@property (strong, nonatomic) UILabel *rateLabel;

@end

@implementation RoundRateView

- (void)awakeFromNib {
    [super awakeFromNib];
    _valueColor = [UIColor new];
    _rateLabel.text = @"?";
    
}

- (void)layoutSubviews {
    
    [self.layer setCornerRadius:self.frame.size.width / 2];
    [_rateLabel setFrame:self.bounds];

    [self setClipsToBounds:YES];
}

- (void)setRoundRateViewValue:(NSNumber *)roundRateViewValue {
    
    _roundRateViewValue = roundRateViewValue;
    
    if (roundRateViewValue) {
        
        float rate = [roundRateViewValue floatValue];
        
        [self.rateLabel setText:[NSString stringWithFormat:@"%.1f",rate]];
    } else {
        
        [self.rateLabel setText:@"?"];
    }
}

- (void)setValueWithString:(NSString *)value {
    
    [self.rateLabel setText:value];
}

- (void)setValueColor:(UIColor *)valueColor {
    
    _valueColor = valueColor;
    [self.rateLabel setTextColor:valueColor];
}


- (UILabel *)rateLabel {
    
    if (!_rateLabel) {
        
        _rateLabel = [UILabel new];
        [_rateLabel setTextAlignment:NSTextAlignmentCenter];
        [_rateLabel setFont:[UIFont fontWithName:@"Helvetica Neue-Light" size:11.f]];
        [_rateLabel setFrame:self.bounds];
        [_rateLabel setMinimumScaleFactor:2];
        [self addSubview:_rateLabel];
    }
    
    return _rateLabel;
}

- (void)setFontName:(NSString *)fontFamily size:(CGFloat)size {
    
    [self.rateLabel setFont:[UIFont fontWithName:fontFamily size:size]];
}

@end
