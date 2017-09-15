//
//  MyCountryWorldScoreHeaderView.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCountryWorldScoreHeaderView : UIView

- (void)setFlagImageByCountryName:(NSString *)countryName;
- (void)setCountryName:(NSString *)countryName;
- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating;
@end
