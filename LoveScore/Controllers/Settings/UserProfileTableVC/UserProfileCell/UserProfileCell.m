//
//  UserProfileCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/4/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "UserProfileCell.h"

@interface UserProfileCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;


@end

@implementation UserProfileCell

#pragma mark - init and system methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

#pragma mark - Public methods

- (void)setName:(NSString *)name {
    _name = name;
    
    [self.nameLabel setText:name];
}

- (void)setInfo:(NSString *)info {
    _info = info;
    
    [self.infoLabel setText:info];
}

@end
