//
//  MapWorldScoreCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/29/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "MapWorldScoreCell.h"

@implementation MapWorldScoreCell

- (void)setCellColor:(CellColor)cellColor {
    _cellColor = cellColor;
    if (cellColor == CellColorDarker) {
        [self setBackgroundColor:[UIColor colorWithRed:243.f / 255.f green:243.f / 255.f blue:243.f / 255.f alpha:1]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}


@end
