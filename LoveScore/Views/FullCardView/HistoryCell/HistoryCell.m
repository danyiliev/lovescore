//
//  HistoryCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/20/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "HistoryCell.h"

@interface HistoryCell () {
    
    IBOutletCollection(UIView) NSArray *_containerViewForLabel;
    IBOutlet UILabel *_dateLable;
    IBOutlet UILabel *_kissLable;
    IBOutlet UILabel *_loveLable;
}

@end

@implementation HistoryCell

#pragma mark - init methods

- (void)layoutSubviews {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContainerView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
}

#pragma mark - Private methods

- (void)setupContainerView {
    CGFloat borderWidth = 2.0f;
    
    for (UIView *view in _containerViewForLabel) {
        [view setBackgroundColor:[UIColor clearColor]];
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = borderWidth;
        view.layer.cornerRadius = 4;
        view.layer.masksToBounds = YES;
    }
}

#pragma mark - Public methods

- (void)setEvents:(NSDictionary *)events {
    if (events.count > 0) {
        if ([events objectForKey:@"DATE"] && ![[events objectForKey:@"DATE"] isEqualToString:@""]) {
            _dateLable.text = [events objectForKey:@"DATE"];
        } else {
            _dateLable.text = @"Soon!";
        }
        
        if ([events objectForKey:@"KISS"] && ![[events objectForKey:@"KISS"] isEqualToString:@""]) {
            _kissLable.text = [events objectForKey:@"KISS"];
        } else {
            _kissLable.text = @"Soon!";
        }
        
        if ([events objectForKey:@"LOVE"] && ![[events objectForKey:@"LOVE"] isEqualToString:@""]) {
            _loveLable.text = [events objectForKey:@"LOVE"];
        } else {
            _loveLable.text = @"Soon!";
        }
    }
}
@end
