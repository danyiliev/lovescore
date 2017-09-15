//
//  HistoryCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/20/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HistoryCellId @"HistoryCellId"

@interface HistoryCell : UITableViewCell

- (void)setEvents:(NSDictionary *)events;

@end
