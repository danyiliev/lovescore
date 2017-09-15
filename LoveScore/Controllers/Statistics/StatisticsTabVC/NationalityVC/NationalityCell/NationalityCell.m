//
//  NationalityCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "StatisticsRateView.h"
#import "NationalityCell.h"

@interface NationalityCell()

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *nationalityLable;
@property (weak, nonatomic) IBOutlet RoundRateView *numberOfGirlsView;
@property (weak, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

@end

@implementation NationalityCell

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

- (void)setFlagImageWithCountryName:(NSString *)countryName {
    self.flagImageView.image = [UIImage imageNamed:countryName];
}

- (void)setNationality:(NSString *)nationality {
    self.nationalityLable.text = nationality;
}

- (void)setNumberOfGirls:(NSInteger)numberOfGirls {
    [self.numberOfGirlsView setValueWithString:[NSString stringWithFormat:@"%li",(long)numberOfGirls]];
}

@end
