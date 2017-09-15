//
//  ChangeNameViewController.h
//  LoveScore
//
//  Created by Vasyl Khmil on 11/11/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationTitle.h"
#import "Global.h"

#import "UserProfileProtocol.h"
#import "User.h"

@interface ChangeNameViewController : UIViewController<UserProfileProtocol>

@property (nonatomic,strong) User *user;

@end
