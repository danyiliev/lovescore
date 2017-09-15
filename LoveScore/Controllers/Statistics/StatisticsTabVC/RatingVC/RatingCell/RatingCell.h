//
//  RatingCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface RatingCell : UITableViewCell

@property (nonatomic)CellColor cellColor;
- (void)setCellColor:(CellColor)cellColor;
- (void)setRate:(NSString *)rate;
- (void)setNumberOfGirls:(NSInteger)numberOfGirls;
- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating;


@end
