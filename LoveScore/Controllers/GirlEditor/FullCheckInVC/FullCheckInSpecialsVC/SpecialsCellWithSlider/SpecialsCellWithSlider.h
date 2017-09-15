//
//  SpecialsCellWithSlider.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/28/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SpecialsCellWithSliderId @"SpecialsCellWithSliderId"

@protocol SpecialsCellWithSliderDelegate <NSObject>

- (void)sliderWithName:(NSString *)parameterName WasChangedWithValue:(NSNumber *)value;

@end

@interface SpecialsCellWithSlider : UITableViewCell

@property (nonatomic, strong) NSString *parameterName;
@property (nonatomic) NSNumber *rate;
@property (nonatomic, weak) id<SpecialsCellWithSliderDelegate> delegate;

@end
