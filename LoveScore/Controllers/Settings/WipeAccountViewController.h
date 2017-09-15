//
//  WipeAccountViewController.h
//  LoveScore
//
//  Created by Vasyl Khmil on 11/11/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileProtocol.h"

@interface WipeAccountViewController : UIViewController<UserProfileProtocol>

@property (nonatomic, strong) NSString *username;

@end
