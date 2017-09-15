//
//  MapWorldScoreCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/29/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "StatisticsRateView.h"

@interface MapWorldScoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *continentNameLbl;
@property (nonatomic)CellColor cellColor;
@property (strong, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

- (void)setCellColor:(CellColor)cellColor;

@end
