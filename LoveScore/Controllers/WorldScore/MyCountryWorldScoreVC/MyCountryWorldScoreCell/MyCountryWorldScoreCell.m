//
//  MyCountryWorldScoreCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "MyCountryWorldScoreCell.h"
#import "StatisticsRateView.h"

@interface MyCountryWorldScoreCell()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

@end

@implementation MyCountryWorldScoreCell

- (void)setCityName:(NSString *)cityName {
    self.cityLabel.text = cityName;
}

- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating {
    [self.statisticRateView setLoveRate:numberWithLoveEvent];
    [self.statisticRateView setKissRate:numberWithKissEvent];
    [self.statisticRateView setFullRate:averageRating];
}

@end
