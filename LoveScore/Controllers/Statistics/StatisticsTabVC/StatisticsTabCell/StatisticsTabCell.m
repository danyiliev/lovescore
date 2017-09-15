//
//  StatisticsTabCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "StatisticsTabCell.h"

@implementation StatisticsTabCell {
    IBOutlet UIImageView *_photoImageView;
    IBOutlet UILabel *_categoryNameLbl;
    CellColor _cellColor;
}

- (void)setCellColor:(CellColor)cellColor {
    _cellColor = cellColor;
    if (cellColor == CellColorDarker) {
        [self setBackgroundColor:[UIColor colorWithRed:243.f / 255.f green:243.f / 255.f blue:243.f / 255.f alpha:1]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setCategoryName:(NSString *)name {
    _categoryNameLbl.text = name;
}

- (void)setImageWithImageName:(NSString *)imageName {
    _photoImageView.image = [UIImage imageNamed:imageName];
}


@end
