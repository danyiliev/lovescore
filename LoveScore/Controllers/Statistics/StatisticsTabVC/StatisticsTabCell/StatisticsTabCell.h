//
//  StatisticsTabCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface StatisticsTabCell : UITableViewCell

- (void)setCellColor:(CellColor)cellColor;
- (void)setCategoryName:(NSString *)name;
- (void)setImageWithImageName:(NSString *)imageName;

@end
