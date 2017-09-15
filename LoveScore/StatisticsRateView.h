//
//  StatisticsRateView.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/4/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundRateView.h"

@interface StatisticsRateView : UIView 

- (void)setLoveRate:(NSNumber *)rate;
- (void)setKissRate:(NSNumber *)rate;
- (void)setLoveRate:(NSNumber *)rate inCountries:(NSInteger)countries;
- (void)setKissRate:(NSNumber *)rate inCountries:(NSInteger)countries;
- (void)setFullRate:(NSNumber *)rate;

@end
