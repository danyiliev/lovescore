//
//  SpecialsCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#define SpecialsCellId @"SpecialsCellId"

#import <UIKit/UIKit.h>
#import "Global.h"

@interface SpecialsCell : UITableViewCell

@property (nonatomic) CellColor specialsCellColor;

@property (nonatomic, strong) NSString *categoryName;

@end
