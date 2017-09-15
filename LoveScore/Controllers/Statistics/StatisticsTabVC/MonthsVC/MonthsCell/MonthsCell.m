//
//  MonthsCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "MonthsCell.h"
#import "StatisticsRateView.h"

@interface MonthsCell()
@property (weak, nonatomic) IBOutlet UILabel *yearLable;
@property (weak, nonatomic) IBOutlet UILabel *monthLable;
@property (weak, nonatomic) IBOutlet RoundRateView *numberOfGirlsView;
@property (weak, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

@end

@implementation MonthsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.numberOfGirlsView setFontName:@"Lato-Regular" size:10];
}

- (void)setCellColor:(CellColor)cellColor {
    _cellColor = cellColor;
    if (cellColor == CellColorDarker) {
        [self setBackgroundColor:[UIColor colorWithRed:243.f / 255.f green:243.f / 255.f blue:243.f / 255.f alpha:1]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setYear:(NSString *)year {
    self.yearLable.text = year;
}

- (void)setMonth:(NSString *)month {
    self.monthLable.text = month;
}

- (void)setNumberOfGirls:(NSInteger)numberOfGirls {
    [self.numberOfGirlsView setValueWithString:[NSString stringWithFormat:@"%li",(long)numberOfGirls]];
}

- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating {
    [self.statisticRateView setLoveRate:numberWithLoveEvent];
    [self.statisticRateView setKissRate:numberWithKissEvent];
    [self.statisticRateView setFullRate:averageRating];
}

@end
