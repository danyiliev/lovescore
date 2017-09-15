//
//  RatingCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "RatingCell.h"
#import "RoundRateView.h"
#import "StatisticsRateView.h"

@interface RatingCell()
@property (weak, nonatomic) IBOutlet RoundRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGirlsLable;
@property (weak, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

@end

@implementation RatingCell

- (void)setCellColor:(CellColor)cellColor {
    _cellColor = cellColor;
    if (cellColor == CellColorDarker) {
        [self setBackgroundColor:[UIColor colorWithRed:243.f / 255.f green:243.f / 255.f blue:243.f / 255.f alpha:1]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setRate:(NSString *)rate {
    
    [self.rateView setValueWithString:rate];
}

- (void)setNumberOfGirls:(NSInteger)numberOfGirls {
    if (numberOfGirls == 1) {
        self.numberOfGirlsLable.text = [NSString stringWithFormat:@"%li Girl",(long)numberOfGirls];
    } else {
        self.numberOfGirlsLable.text = [NSString stringWithFormat:@"%li Girls",(long)numberOfGirls];
    }
}

- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating {
    [self.statisticRateView setLoveRate:numberWithLoveEvent];
    [self.statisticRateView setKissRate:numberWithKissEvent];
    [self.statisticRateView setFullRate:averageRating];
}



@end
