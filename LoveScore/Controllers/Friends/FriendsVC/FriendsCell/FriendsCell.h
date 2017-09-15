//
//  FriendsCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/10/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "SWTableViewCell.h"



@interface FriendsCell : SWTableViewCell

@property (nonatomic, strong) NSString *nameString;
@property (weak, nonatomic) IBOutlet UIImageView *swipeCellView;

@end
