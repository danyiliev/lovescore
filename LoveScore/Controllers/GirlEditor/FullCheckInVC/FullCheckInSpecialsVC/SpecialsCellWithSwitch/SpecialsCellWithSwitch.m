//
//  SpecialsCellWithSwitch.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SpecialsCellWithSwitch.h"

@interface SpecialsCellWithSwitch ()

@property (strong, nonatomic) IBOutlet UILabel *parameterLabel;

@property (strong, nonatomic) IBOutlet UISwitch *parameterSwitch;

@end

@implementation SpecialsCellWithSwitch

#pragma mark - init methods

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isSwitchTurnOn = self.parameterSwitch.isOn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public methods

- (void)setIsSwitchTurnOn:(BOOL)isSwitchTurnOn {
    _isSwitchTurnOn = isSwitchTurnOn;
    [_parameterSwitch setOn:isSwitchTurnOn animated:NO];
    
    if (isSwitchTurnOn) {
        if([self.delegate respondsToSelector:@selector(switchWasTurnOn:)]) {
            [self.delegate switchWasTurnOn:self.parameterName];
        }
    } else {
        if([self.delegate respondsToSelector:@selector(switchWasTurnOff:)]) {
            [self.delegate switchWasTurnOff:self.parameterName];
        }
    }
}

- (void)setParameterName:(NSString *)parameterName   {
    _parameterName = parameterName;
    
    [_parameterLabel  setText:parameterName];
}

#pragma mark - IBoutlets
- (IBAction)sliderValueWasChanged:(UISwitch *)sender {
    self.isSwitchTurnOn = !self.isSwitchTurnOn;
}

@end
