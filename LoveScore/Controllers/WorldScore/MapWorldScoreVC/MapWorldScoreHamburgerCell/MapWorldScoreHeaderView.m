//
//  MapWorldScoreHeaderView.m
//  LoveScore
//
//  Created by Timur Umayev on 4/28/16.
//  Copyright © 2016 Rarefields. All rights reserved.
//

#import "MapWorldScoreHeaderView.h"

@implementation MapWorldScoreHeaderView

- (IBAction)onHeaderClick:(id)sender {
    [_delegate didSelectHeaderAtIndex:self.index];
}

- (void)setCellColor:(CellColor)cellColor {
    _cellColor = cellColor;
    if (cellColor == CellColorDarker) {
        [self.view setBackgroundColor:[UIColor colorWithRed:243.f / 255.f green:243.f / 255.f blue:243.f / 255.f alpha:1]];
    } else {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
}


@end
