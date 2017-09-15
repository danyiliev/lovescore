//
//  StatisticsWorldScoreCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/27/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "ProgressView.h"

@interface StatisticsWorldScoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *continentNameLbl;

@property (weak, nonatomic) IBOutlet ProgressView *progressView;

@property (nonatomic)CellColor cellColor;

@property (weak, nonatomic) IBOutlet UILabel *countOfGirlsLabel;

- (void)setCellColor:(CellColor)cellColor;
- (void)setCountOfGirls:(NSInteger)countOfGirls numberOfAllGirls:(NSInteger)numberOfAllGirls;

@end
