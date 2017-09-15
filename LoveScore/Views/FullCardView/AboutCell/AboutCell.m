//
//  AboutCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "AboutCell.h"

@interface AboutCell ()  {
    
    IBOutlet UILabel *_categoryLabel;
    IBOutlet UILabel *_infoLabel;
}

@end

@implementation AboutCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)setAboutCellColor:(CellColor)aboutCellColor {
    
    if (aboutCellColor == CellColorLighter) {
        [self setBackgroundColor:[UIColor colorWithRed:172.f / 255.f green:52.f / 255.f blue:54.f / 255.f alpha:1]];
    } else {
        [self setBackgroundColor:[UIColor colorWithRed:175.f / 255.f green:61.f / 255.f blue:57.f / 255.f alpha:1]];
    }
}

- (void)setInfoText:(NSString *)infoText {
    _infoText = infoText;
    [_infoLabel setText:infoText];
}

- (void)setCategoryName:(NSString *)categoryName {
    _categoryName = categoryName;
    [_categoryLabel setText:categoryName];
}

@end
