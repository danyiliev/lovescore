//
//  DateHistoryCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "DateHistoryCell.h"

@interface DateHistoryCell()
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventLable;
@property (weak, nonatomic) IBOutlet RoundRateView *numberOfGrilsView;
@property (weak, nonatomic) IBOutlet RoundRateView *rateView;

@end

@implementation DateHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.numberOfGrilsView setFontName:@"Lato-Regular" size:10];
    [self.rateView setFontName:@"Lato-Regular" size:14];
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

- (void)setEventImageWithName:(NSString *)name {
    self.eventImageView.image = [UIImage imageNamed:name];
}

- (void)setEventTitle:(NSString *)title {
    self.eventLable.text = title;
}

- (void)setNumberOfGirls:(NSNumber *)numberOfGirls {
    [self.numberOfGrilsView setValueWithString:[NSString stringWithFormat:@"%li",(long)[numberOfGirls integerValue]]];
}

- (void)setAverageRating:(NSNumber *)rate {
    
    if (isnan([rate floatValue])) {
        [self.rateView setValueWithString:@"?"];
    } else {
        [self.rateView setRoundRateViewValue:rate];
    }
}

@end
