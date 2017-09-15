//
//  SocialCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/20/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SocialCell.h"

@interface SocialCell () {
    
    IBOutlet UIImageView *_iconImageView;
    IBOutlet UILabel *_nameLabel;

}

@end

@implementation SocialCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public Methods

- (void)setSocialCellColor:(CellColor)socialCellColor {
    if (socialCellColor == CellColorLighter) {
        [self setBackgroundColor:[UIColor colorWithRed:172.f / 255.f green:52.f / 255.f blue:54.f / 255.f alpha:1]];
    } else {
        [self setBackgroundColor:[UIColor colorWithRed:175.f / 255.f green:61.f / 255.f blue:57.f / 255.f alpha:1]];
    }
}

- (void)setSocialNameString:(NSString *)socialNameString {
    _socialNameString = socialNameString;
    [_nameLabel setText:socialNameString];
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    [_iconImageView setImage:iconImage];
}

@end
