//
//  StaticticsWorldScoreHamburgerCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/28/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"

@interface StaticticsWorldScoreHamburgerCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *continentNameLbl;
@property (weak, nonatomic) IBOutlet ProgressView *progressView;
@property (nonatomic) NSInteger amountOfCells;
@property (weak, nonatomic) IBOutlet UIView *continentView;
@property (nonatomic, strong)NSDictionary *statistics;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGirlsLable;

- (void)setCountOfGirls:(NSInteger)countOfGirls numberOfAllGirls:(NSInteger)numberOfAllGirls;

@end
