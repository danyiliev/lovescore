//
//  DateHistoryCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "RoundRateView.h"


@interface DateHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet RoundRateView *smallRateView;
@property (weak, nonatomic) IBOutlet RoundRateView *bigRateView;
@property (nonatomic)CellColor cellColor;

- (void)setCellColor:(CellColor)cellColor;
- (void)setEventImageWithName:(NSString *)name;
- (void)setEventTitle:(NSString *)title;
- (void)setNumberOfGirls:(NSNumber *)numberOfGirls;
- (void)setAverageRating:(NSNumber *)rate;

@end
