//
//  UserProfileCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/4/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UserProfileCellId @"UserProfileCellId"

@interface UserProfileCell : UITableViewCell

@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSString *info;

@end
