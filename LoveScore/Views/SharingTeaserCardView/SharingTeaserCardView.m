//
//  SharingTeaserCardView.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SharingTeaserCardView.h"
#import "RoundRateView.h"
#import "ImageManager.h"
#import "CoreDataManager.h"

@interface SharingTeaserCardView ()

@property (strong, nonatomic) IBOutlet RoundRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UILabel *nationalityLable;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *countryFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation SharingTeaserCardView

#pragma mark - Private methods
- (UIImage *)getEventImageFromEventDictionary:(NSDictionary *)eventDictionary {
    UIImage *image = [UIImage new];
    if ([eventDictionary isKindOfClass:[NSDictionary class]]) {
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
#pragma mark - Public methods

- (void)setPersonModel:(Person *)person {
    [self.rateView setFontName:@"Lato-Regular" size:11];
    if (person.lastName) {
        [self.nameLable setText:[NSString stringWithFormat:@"%@ %@",person.firstName, person.lastName]];
    } else {
        [self.nameLable setText:person.firstName];
    }
    
    [self.eventImageView setImage:[self getEventImageFromEventDictionary:person.events]];
    [self.rateView setRoundRateViewValue:person.rating];
    [self.ageLable setText:[person.age stringValue]];
    NSDictionary *countriesDictionary = [[CoreDataManager instance] getCountriesDictionaryFromDataBase];
    [self.nationalityLable setText:[countriesDictionary objectForKey:person.nationality]];
    [self.commentTextView setText:person.comment];
    [self.commentTextView setTextColor:[UIColor whiteColor]];
    
    [self.countryFlagImageView setImage:person.flagImage];
}

- (void)setPhotoWithString:(NSString *)string {
    [self.photoImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]]];
}

- (void)loadImageWithPhotoUUID:(NSString *)photoUUID {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dictionary = [ImageManager sharedInstance].avatarDictionaries;
        UIImage *image =  [UIImage imageWithContentsOfFile:[dictionary objectForKey:photoUUID]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // callback
            [UIView transitionWithView:self.photoImageView
                              duration:0.2f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                if (image) {
                                    self.photoImageView.image = image;
                                } else {
                                    [self.photoImageView setImage:[UIImage imageNamed:@"checkin-avatar-nocamera"]];
                                }
                                
                            } completion:nil];
            
        });
    });
}

@end
