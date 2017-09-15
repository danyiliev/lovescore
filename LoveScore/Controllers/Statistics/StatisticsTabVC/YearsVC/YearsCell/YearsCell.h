//
//  YearsCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "RoundRateView.h"

@interface YearsCell : UITableViewCell

@property (nonatomic)CellColor cellColor;

- (void)setCellColor:(CellColor)cellColor;
- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating;
- (void)setYear:(NSString *)year;
- (void)setCountOfGirls:(NSInteger)numberOfGirls;
@end
