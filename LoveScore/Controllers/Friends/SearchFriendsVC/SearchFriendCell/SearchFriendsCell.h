//
//  SearchFriendsCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/4/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#define SearchFriendsCellId @"SearchFriendsCellId"

typedef enum {
    FriendsCellStateAdd = 0,
    FriendsCellStateNotAdded,
    FriendsCellStateSentRequest,
    FriendsCellStateNone
}FriendsCellState;

#import <UIKit/UIKit.h>

@interface SearchFriendsCell : UITableViewCell

@property (nonatomic) FriendsCellState friendState;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *displayName;

@end
