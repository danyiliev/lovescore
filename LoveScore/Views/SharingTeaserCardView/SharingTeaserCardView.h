//
//  SharingTeaserCardView.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "Person.h"

@interface SharingTeaserCardView : UIView

@property (nonatomic) StoryType storyType;

- (void)setPersonModel:(Person *)person;
- (void)setPhotoWithString:(NSString *)string;
- (void)loadImageWithPhotoUUID:(NSString *)photoUUID;

@end
