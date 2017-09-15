//
//  AgeCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "AgeCell.h"
#import "StatisticsRateView.h"

@implementation AgeCell {
    IBOutlet UILabel *ageRangeLable;
    IBOutlet UILabel *numberOfGirlsLable;
    IBOutlet StatisticsRateView *statisticRateView;
}

- (void)setCellColor:(CellColor)cellColor {
    _cellColor = cellColor;
    if (cellColor == CellColorDarker) {
        [self setBackgroundColor:[UIColor colorWithRed:243.f / 255.f green:243.f / 255.f blue:243.f / 255.f alpha:1]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setAgeRange:(NSString *)range {
    ageRangeLable.text = range;
}

- (void)setNumberOfGirls:(NSInteger)numberOfGirls {
    if (numberOfGirls == 1) {
        numberOfGirlsLable.text = [NSString stringWithFormat:@"%li Girl",(long)numberOfGirls];
    } else {
        numberOfGirlsLable.text = [NSString stringWithFormat:@"%li Girls",(long)numberOfGirls];
    }
}

- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating {
    [statisticRateView setLoveRate:numberWithLoveEvent];
    [statisticRateView setKissRate:numberWithKissEvent];
    [statisticRateView setFullRate:averageRating];
}

@end
