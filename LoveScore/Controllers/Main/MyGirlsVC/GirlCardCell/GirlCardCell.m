//
//  GirlCardCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/15/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "GirlCardCell.h"
#import "StarRatingView.h"
#import "ImageManager.h"

@implementation GirlCardCell {
    __weak IBOutlet StarRatingView *_starRateView;
    IBOutlet UIImageView *_mainPhotoImageView;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_mainPhotoImageView setImage:[UIImage imageNamed:@"checkin-avatar-upload"]];
    _mainPhotoImageView.clipsToBounds = YES;
    _starRateView.tintColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
}

- (void) prepareForReuse {
    [super prepareForReuse];
    [_mainPhotoImageView setImage:[UIImage imageNamed:@"checkin-avatar-upload"]];
}

- (void)setRate:(NSNumber *)rate {
    [_starRateView setValue:[rate floatValue]];
}

- (void)setPhotoPath:(NSString *)photoPath {
    _photoPath = photoPath;
    [_mainPhotoImageView setImage:[UIImage imageWithContentsOfFile:photoPath]];
}

- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
    if (photo) {
        [_mainPhotoImageView setImage:photo];
    }
}

- (void)setFlagImageWithCountryName:(NSString *)countryName {
    [_flagImageView setImage:[UIImage imageNamed:countryName]];
}

- (void)loadImageWithPhotoUUID:(NSString *)photoUUID {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image =  [UIImage imageWithContentsOfFile:[[ImageManager sharedInstance].avatarDictionaries objectForKey:photoUUID]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (image) {
                _mainPhotoImageView.image = image;
            } else {
                [_mainPhotoImageView setImage:[UIImage imageNamed:@"checkin-avatar-nocamera"]];
            }
        });
    });
}


@end
