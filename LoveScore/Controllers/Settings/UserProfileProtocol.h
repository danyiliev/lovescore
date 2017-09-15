//
//  UserProfileProtocol.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/5/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@protocol UserProfileProtocol <NSObject>

@optional
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *username;

@end
