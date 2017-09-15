//
//  SmallCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/28/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SmallCell.h"
#import "StatisticsRateView.h"

@interface SmallCell()

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

@end

@implementation SmallCell

- (void)setFlagImageWithCountryName:(NSString *)countryName {
    self.flagImageView.image = [UIImage imageNamed:countryName];
}

- (void)setCountryName:(NSString *)countryName {
    self.countryLabel.text = countryName;
}

- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating {
    
    [self.statisticRateView setLoveRate:numberWithLoveEvent];
    [self.statisticRateView setKissRate:numberWithKissEvent];
    [self.statisticRateView setFullRate:averageRating];
}

@end
