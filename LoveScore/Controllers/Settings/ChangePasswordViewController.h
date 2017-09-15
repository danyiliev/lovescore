//
//  ChangePasswordViewController.h
//  LoveScore
//
//  Created by Vasyl Khmil on 11/10/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileProtocol.h"
#import "User.h"

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate, UserProfileProtocol>

@property (nonatomic, strong) NSString *username;

@end
