//
//  TeaserCardView.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/21/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "TeaserCardView.h"
#import "StarRatingView.h"
#import "ImageManager.h"
#import "CoreDataManager.h"

@interface TeaserCardView ()

@property (weak, nonatomic) IBOutlet StarRatingView *starRateView;
@property (strong, nonatomic) IBOutlet UIImageView *flagImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation TeaserCardView

#pragma mark - Private

- (UIImage *)getEventImageFromEventDictionary:(NSDictionary *)eventDictionary {
    UIImage *image = [UIImage new];
    if (eventDictionary.count > 0) {
        if ([eventDictionary objectForKey:@"LOVE"]) {
            image = [UIImage imageNamed:@"heart_in_oval"];
        } else if ([eventDictionary objectForKey:@"KISS"]) {
            image = [UIImage imageNamed:@"lips_in_oval"];
        } else if ([eventDictionary objectForKey:@"DATE"]) {
            image = [UIImage imageNamed:@"bubble_in_oval"];
        }
    }
    return image;
}

#pragma mark - Public

- (void)setPersonModel:(Person *)person {
    
    if (person.lastName) {
        [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@",person.firstName, person.lastName]];
    } else {
        [self.nameLabel setText:person.firstName];
    }
    [self.storyImageView setImage:[self getEventImageFromEventDictionary:person.events]];
    [_starRateView setValue:[person.rating floatValue]];
    
    // photo setup
    [self.flagImageView setImage:person.flagImage];
    UIImage *avatarImage = [[ImageManager sharedInstance] getAvatarImageForUUID:person.uuid];
    
    if (avatarImage) {
        [self.photoImageView setImage:avatarImage];
    } else {
        [self.photoImageView setImage:[UIImage imageNamed:@"default-avatar"]];
    }
}

@end
