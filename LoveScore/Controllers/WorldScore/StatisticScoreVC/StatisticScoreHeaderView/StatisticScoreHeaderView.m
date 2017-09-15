//
//  StatisticScoreHeaderView.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 3/16/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "StatisticScoreHeaderView.h"

@interface StatisticScoreHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *tuchButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;

@end

@implementation StatisticScoreHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)tuchAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didSelectHeaderAtIndex:)]) {
        [_delegate didSelectHeaderAtIndex:self.index];
    }
    
}

- (void)layoutSubviews {
    if ([[UIScreen mainScreen] bounds].size.width < 370) {
        self.progressViewWidth.constant = 105;
    }
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
