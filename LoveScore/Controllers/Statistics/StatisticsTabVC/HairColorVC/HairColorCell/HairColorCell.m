//
//  HairColorCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "StatisticsRateView.h"
#import "HairColorCell.h"

@interface HairColorCell()

@property (weak, nonatomic) IBOutlet UIImageView *hairColorImageView;
@property (weak, nonatomic) IBOutlet UILabel *hairColorLabel;
@property (weak, nonatomic) IBOutlet RoundRateView *numberOfGirlsView;
@property (weak, nonatomic) IBOutlet StatisticsRateView *statisticRateView;


@end

@implementation HairColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.rateView setFontName:@"Lato-Regular" size:10];
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

- (void)setHairColorImageWithString:(NSString *)hairColorString {
    self.hairColorImageView.image = [UIImage imageNamed:hairColorString];
}

- (void)setHairColorText:(NSString *)hairColor {
    self.hairColorLabel.text = hairColor;
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
