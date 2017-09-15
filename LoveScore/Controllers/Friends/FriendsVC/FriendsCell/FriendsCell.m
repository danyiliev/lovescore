//
//  FriendsCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/10/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FriendsCell.h"

@interface FriendsCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FriendsCell

- (void)setNameString:(NSString *)nameString  {
    
    _nameString = nameString;
    [self.nameLabel setText:nameString];
}
@end
