//
//  NationalityCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "RoundRateView.h"


@interface NationalityCell : UITableViewCell
@property (nonatomic)CellColor cellColor;

- (void)setCellColor:(CellColor)cellColor;
- (void)setFlagImageWithCountryName:(NSString *)countryName;
- (void)setNationality:(NSString *)nationality;
- (void)setNumberOfGirls:(NSInteger)numberOfGirls;
- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating;

@end
