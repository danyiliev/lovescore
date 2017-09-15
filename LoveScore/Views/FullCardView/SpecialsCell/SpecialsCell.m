//
//  SpecialsCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SpecialsCell.h"

@interface SpecialsCell () {
    
    IBOutlet UIImageView *_tickImageView;
    IBOutlet UILabel *_categoryLabel;
}

@end

@implementation SpecialsCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
}

#pragma mark - Public Methods

- (void)setSpecialsCellColor:(CellColor)specialsCellColor  {
    if (specialsCellColor == CellColorLighter) {
        [self setBackgroundColor:[UIColor colorWithRed:172.f / 255.f green:52.f / 255.f blue:54.f / 255.f alpha:1]];
    } else {
        [self setBackgroundColor:[UIColor colorWithRed:175.f / 255.f green:61.f / 255.f blue:57.f / 255.f alpha:1]];
    }
}

- (void)setCategoryName:(NSString *)categoryName {
    [_categoryLabel setText:categoryName];
}

@end
