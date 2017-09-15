//
//  AboutCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#define AboutCellId @"AboutCellId"

#import <UIKit/UIKit.h>
#import "Global.h"  

@interface AboutCell : UITableViewCell

@property (nonatomic) CellColor aboutCellColor;

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *infoText;

@end
