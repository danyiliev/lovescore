//
//  SearchFriendsCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/4/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SearchFriendsCell.h"
#import "TTTAttributedLabel.h"

@interface SearchFriendsCell ()
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *nameLabel;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *acceptFriendView;
@property (strong, nonatomic) IBOutlet UIImageView *stateButton;

@end

@implementation SearchFriendsCell

#pragma mark - Public methods


- (void)setUsername:(NSString *)username {
    _username = username;
    [self.nameLabel setText:username];
}

- (void)setDisplayName:(NSString *)displayName {
    _displayName = displayName;
    
    NSString *labelText = self.username;
    
    labelText = [labelText stringByAppendingString:[NSString stringWithFormat:@"(%@)", displayName]];
    
    [self.nameLabel setText:labelText
afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
    
    NSRange redRange = [labelText rangeOfString:[NSString stringWithFormat:@"(%@)", displayName]];
    if (redRange.location != NSNotFound) {
        
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RED_COLOR.CGColor range:redRange];
    }
    
    return mutableAttributedString;
}];

}

- (void)setFriendState:(FriendsCellState)friendState {
    _friendState = friendState;
    switch (friendState) {
        case FriendsCellStateAdd: {
            [self.stateButton setImage:[UIImage imageNamed:@"friends-icon-added"]];
            [self.acceptFriendView setHidden:NO];
        }
            break;
        case FriendsCellStateNotAdded: {
            [self.stateButton setImage:[UIImage imageNamed:@"edit_history_plus"] ];
            [self.acceptFriendView setHidden:YES];
        }
            break;
        case FriendsCellStateSentRequest: {
            [self.stateButton setImage:[UIImage imageNamed:@"friends-icon-pending"] ];
            [self.acceptFriendView setHidden:YES];
            
        }
            break;
        case FriendsCellStateNone: {
            [self.stateButton setImage:nil];
            [self.acceptFriendView setHidden:YES];
        }
            break;
            
        default:
            break;
    }
}


@end
