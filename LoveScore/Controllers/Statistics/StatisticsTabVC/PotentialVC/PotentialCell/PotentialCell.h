//
//  PotentialCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "RoundRateView.h"

@interface PotentialCell : UITableViewCell

@property (nonatomic)CellColor cellColor;

- (void)setCellColor:(CellColor)cellColor;
- (void)setPotentialText:(NSString *)text;
- (void)setNumberOfGirls:(NSInteger)numberOfGirls;
- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating;

@end
