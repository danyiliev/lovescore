//
//  AgeCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "StatisticsRateView.h"


@interface AgeCell : UITableViewCell
@property (nonatomic)CellColor cellColor;
@property (strong, nonatomic)StatisticsRateView *rateView;
- (void)setAgeRange:(NSString *)range;
- (void)setNumberOfGirls:(NSInteger)numberOfGirls;
- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating;
@end
