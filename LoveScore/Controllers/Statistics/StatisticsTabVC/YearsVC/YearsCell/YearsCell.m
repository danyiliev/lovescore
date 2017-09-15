//
//  YearsCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "YearsCell.h"
#import "StatisticsRateView.h"

@interface YearsCell()

@property (weak, nonatomic) IBOutlet UILabel *yearLable;
@property (weak, nonatomic) IBOutlet RoundRateView *numberOfGirls;
@property (weak, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

@end

@implementation YearsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.numberOfGirls setFontName:@"Lato-Regular" size:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (void)setCountOfGirls:(NSInteger)numberOfGirls {
    [self.numberOfGirls setValueWithString:[NSString stringWithFormat:@"%li",(long)numberOfGirls]];
}

- (void)setYear:(NSString *)year {
    self.yearLable.text = year;
}

@end
