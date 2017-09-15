//
//  RoundDoubleRateView.h
//  LoveScore
//
//  Created by Marcin Podeszwa on 7/5/17.
//  Copyright © 2017 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtededView.h"

@interface RoundDoubleRateView : ExtededView

- (void)setFontName:(NSString *)fontFamily size:(CGFloat)size;
- (void)setValueWithString1:(NSString *)value1 string2:(NSString *)value2;

@end
