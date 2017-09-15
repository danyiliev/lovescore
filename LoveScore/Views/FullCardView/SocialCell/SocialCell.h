//
//  SocialCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/20/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#define SocialCellId @"SocialCellId"

#import <UIKit/UIKit.h>
#import "Global.h"

@interface SocialCell : UITableViewCell 

@property (nonatomic) CellColor socialCellColor;
@property (nonatomic, strong) NSString *socialNameString;
@property (nonatomic, strong) UIImage *iconImage;

@end
