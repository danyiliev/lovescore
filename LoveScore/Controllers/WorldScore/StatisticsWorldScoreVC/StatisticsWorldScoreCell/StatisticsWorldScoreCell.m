//
//  StatisticsWorldScoreCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/27/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "StatisticsWorldScoreCell.h"

@interface StatisticsWorldScoreCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;

@end

@implementation StatisticsWorldScoreCell

- (void)layoutSubviews {
    if ([[UIScreen mainScreen] bounds].size.width < 370) {
        self.progressViewWidth.constant = 105;
    }
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

- (void)setCountOfGirls:(NSInteger)countOfGirls numberOfAllGirls:(NSInteger)numberOfAllGirls {
    self.countOfGirlsLabel.text = [NSString stringWithFormat:@"%li of %li",(long)countOfGirls,(long)numberOfAllGirls];
}

@end
