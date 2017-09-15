//
//  SideMenuCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/12/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#define SideMenuCellId @"SideMenuCellId"

#import <UIKit/UIKit.h>

@interface SideMenuCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *notificationMark;

@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;

- (void)removeSeparator;
@end
