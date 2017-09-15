//
//  Friend.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 12/7/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    FriendStateIncoming = 0,
    FriendStateOutcoming,
    FriendStateCurrentFriend,
    FriendStatePotential
}FriendState;

@interface Friend : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic) FriendState friendState;

@end
