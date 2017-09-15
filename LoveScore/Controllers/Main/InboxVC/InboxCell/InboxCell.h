//
//  InboxCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/3/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetrieveInbox.h"

typedef enum {
  InboxCellStateIncomingRead = 0,
    InboxCellStateIncomingNotRead,
    InboxCellStateOutcomingRead,
    InboxCellStateOutcomingNotRead
} InboxCellState;

@interface InboxCell : UITableViewCell

@property (nonatomic)InboxCellState inboxCellState;

- (void)setRetrieveInboxModel:(RetrieveInbox *)retrieveModel;

@end
