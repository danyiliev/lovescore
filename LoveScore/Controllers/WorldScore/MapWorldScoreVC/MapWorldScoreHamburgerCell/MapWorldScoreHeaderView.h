//
//  MapWorldScoreHeaderView.h
//  LoveScore
//
//  Created by Timur Umayev on 4/28/16.
//  Copyright © 2016 Rarefields. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticsRateView.h"

@protocol MapWorldScoreHeaderView <NSObject>

- (void)didSelectHeaderAtIndex:(NSInteger)index;

@end

@interface MapWorldScoreHeaderView : UIView

@property (assign, nonatomic)NSInteger index;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *continentNameLbl;
@property (weak, nonatomic) id <MapWorldScoreHeaderView> delegate;
@property (nonatomic)CellColor cellColor;

@property (strong, nonatomic) IBOutlet StatisticsRateView *statisticRateView;

@end
