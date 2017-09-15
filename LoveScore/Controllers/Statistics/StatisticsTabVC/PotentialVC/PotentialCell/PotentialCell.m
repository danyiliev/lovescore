//
//  PotentialCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "PotentialCell.h"
#import "StatisticsRateView.h"
#import "RoundRateView.h"

@interface PotentialCell()

@property (weak, nonatomic) IBOutlet UILabel *potentialLable;
@property (weak, nonatomic) IBOutlet RoundRateView *numberOfGirlsView;
@property (weak, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

@end

@implementation PotentialCell

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

- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating {
    [self.statisticRateView setLoveRate:numberWithLoveEvent];
    [self.statisticRateView setKissRate:numberWithKissEvent];
    [self.statisticRateView setFullRate:averageRating];
}

- (void)setPotentialText:(NSString *)text {
    self.potentialLable.text = text;
}

- (void)setNumberOfGirls:(NSInteger)numberOfGirls {
    [self.numberOfGirlsView setValueWithString:[NSString stringWithFormat:@"%li",(long)numberOfGirls]];
}



@end
