//
//  LuckyListCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/20/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#define LuckyListCellId @"LuckyListCellId"

#import <UIKit/UIKit.h>
#import "Global.h"
#import "Person.h"

@interface LuckyListCell : UITableViewCell


@property (nonatomic) CellColor luckyListCellColor;
@property (nonatomic)NSInteger girlNumber;

- (void)setPerson:(Person *)person cellNumber:(NSInteger)cellNUmber countriesDictionary:(NSDictionary *)countriesDictionary rating:(NSNumber *)rating;

@end
