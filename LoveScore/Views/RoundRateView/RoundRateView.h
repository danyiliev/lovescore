//
//  RoundRateView.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/27/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtededView.h"
IB_DESIGNABLE

@interface RoundRateView : ExtededView

@property (nonatomic, strong) IBInspectable NSNumber *roundRateViewValue;
@property (nonatomic, strong) IBInspectable UIColor *valueColor;

- (void)setFontName:(NSString *)fontFamily size:(CGFloat)size;
- (void)setValueWithString:(NSString *)value;

@end
