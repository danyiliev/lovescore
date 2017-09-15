//
//  StatisticScoreHeaderView.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 3/16/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"


@protocol StatisticScoreHeaderViewDelegate <NSObject>

- (void)didSelectHeaderAtIndex:(NSInteger)index;

@end

@interface StatisticScoreHeaderView : UIView

@property (assign, nonatomic)NSInteger index;
@property (weak, nonatomic) id <StatisticScoreHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *continentNameLbl;

@property (weak, nonatomic) IBOutlet ProgressView *progressView;

@property (nonatomic)CellColor cellColor;

@property (weak, nonatomic) IBOutlet UILabel *countOfGirlsLabel;

- (void)setCellColor:(CellColor)cellColor;
- (void)setCountOfGirls:(NSInteger)countOfGirls numberOfAllGirls:(NSInteger)numberOfAllGirls;

@end
