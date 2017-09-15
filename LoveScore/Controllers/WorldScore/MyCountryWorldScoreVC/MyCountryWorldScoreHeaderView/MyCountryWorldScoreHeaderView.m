//
//  MyCountryWorldScoreHeaderView.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "StatisticsRateView.h"
#import "MyCountryWorldScoreHeaderView.h"

@interface MyCountryWorldScoreHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

@end

@implementation MyCountryWorldScoreHeaderView

- (void)setFlagImageByCountryName:(NSString *)countryName {
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
