//
//  MonthsCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "RoundRateView.h"

@interface MonthsCell : UITableViewCell

@property (nonatomic)CellColor cellColor;

- (void)setYear:(NSString *)year;
- (void)setMonth:(NSString *)month;
- (void)setNumberOfGirls:(NSInteger)numberOfGirls;
- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating;

@end
