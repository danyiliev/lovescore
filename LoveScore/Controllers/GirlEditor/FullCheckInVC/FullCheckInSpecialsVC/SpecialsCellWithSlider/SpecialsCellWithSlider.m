//
//  SpecialsCellWithSlider.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/28/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SpecialsCellWithSlider.h"
#import "RoundRateView.h"

@interface SpecialsCellWithSlider ()

@property (strong, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet RoundRateView *rateView;
@property (strong, nonatomic) IBOutlet UILabel *parameterLabel;
@end

@implementation SpecialsCellWithSlider

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.slider addTarget:self action:@selector(sliderEditingFinished:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    
    [self.rateView setFontName:@"Lato-Light" size:11];
}

- (void)layoutSubviews {
    
    [_slider setThumbImage:[UIImage imageNamed:@"ui-slider-button"] forState:UIControlStateNormal];
}

- (void)setRate:(NSNumber *)rate {
    _rate = rate;
    [self.rateView setRoundRateViewValue:rate];
    if (rate) {
        [self.slider setValue:[rate floatValue]];
    } else {
        [self.slider setValue:5.f];
    }
}

- (void)setParameterName:(NSString *)parameterName {
    _parameterName = parameterName;
    
    [_parameterLabel setText:parameterName];
}

- (IBAction)sliderValueChange:(UISlider *)slider {
    [self.rateView setRoundRateViewValue:[NSNumber numberWithFloat:slider.value]];
}

- (IBAction)sliderEditingFinished:(UISlider *)slider {
    if ([self.delegate respondsToSelector:@selector(sliderWithName:WasChangedWithValue:)]) {
        [self.delegate sliderWithName:self.parameterName WasChangedWithValue:[NSNumber numberWithFloat:slider.value]];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
