//
//  SendToCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SendToCell.h"

@implementation SendToCell

- (IBAction)checkBoxHandle:(UIButton *)sender {
    if ([sender isSelected]) {
        [sender setSelected:NO];
        
        if ([_delegate respondsToSelector:@selector(deselectUsername:)]) {
            [_delegate deselectUsername:self.usernameLbl.text];
        }
    } else {
        [sender setSelected:YES];
        
        if ([_delegate respondsToSelector:@selector(selectUsername:)]) {
            [_delegate selectUsername:self.usernameLbl.text];
        }
    }
}

@end
