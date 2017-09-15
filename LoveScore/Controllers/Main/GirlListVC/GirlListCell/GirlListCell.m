//
//  GirlListCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/13/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "GirlListCell.h"
#import "UIImage+ImageAdditions.h"
#import "ImageManager.h"
#import "NetworkActivityIndicator.h"
#import "StarRatingView.h"

@interface GirlListCell () {
    IBOutlet UIImageView *_iconImageView;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_yearAndCityLabel;
    __weak IBOutlet StarRatingView *_starRateView;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSOperation *fullImageRequestOperation;

@end

@implementation GirlListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // set photo layer
    _photoImageView.layer.cornerRadius = _photoImageView.frame.size.height / 2;
    _photoImageView.clipsToBounds = YES;
    
    // label
    [_nameLabel sizeToFit];
    [_yearAndCityLabel sizeToFit];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

#pragma mark - Public methods

- (void)setGirlListCellColor:(CellColor)girlListCellColor {
    _girlListCellColor = girlListCellColor;
    if (girlListCellColor == CellColorDarker) {
        [self setBackgroundColor:[UIColor colorWithRed:243.f / 255.f green:243.f / 255.f blue:243.f / 255.f alpha:1]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setName:(NSString *)name surname:(NSString *)surname {
    if (surname && ![surname isEqualToString:@""]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@", name, surname];
    } else {
        _nameLabel.text = name;
    }
}

- (void)setPhoto:(UIImage *)photo {
    
    // set photo layer
    if (photo) {
        [_photoImageView setImage:photo];
        _photoImageView.layer.cornerRadius = _photoImageView.frame.size.height / 2;
        _photoImageView.clipsToBounds = YES;
    }
}

- (void)setIconForEvent:(NSDictionary *)eventsDictionary {
    id dateDate = [eventsDictionary objectForKey:@"DATE"];
    id kissDate = [eventsDictionary objectForKey:@"KISS"];
    id loveDate = [eventsDictionary objectForKey:@"LOVE"];
    
    if (dateDate) {
        [_iconImageView setImage:[UIImage imageNamed:@"edit-icons-bubble"]];
    }
    if (kissDate) {
        [_iconImageView setImage:[UIImage imageNamed:@"edit-icons-mouth"]];
    }
    if (loveDate) {
        [_iconImageView setImage:[UIImage imageNamed:@"edit-icons-heart"]];
    }
}

- (void)setFlag:(NSString *)flagString {
    _flagImageView.image = [UIImage imageNamed:flagString];
}

- (void)setAge:(NSString *)age country:(NSString *)country city:(NSString *)city {
    if (city &&![city isEqual:[NSNull null]]) {
        
        _yearAndCityLabel.text = [NSString stringWithFormat:@"%@ | %@, %@",age,city,country];
    } else if (([city isEqual:[NSNull null]] || !city ) && ([country isEqual:[NSNull null]] || !country)) {
        _yearAndCityLabel.text = [NSString stringWithFormat:@"%@ years",age];
    } else {
        _yearAndCityLabel.text = [NSString stringWithFormat:@"%@ | %@",age,country];
    }
}

- (void)setRate:(NSNumber *)rate {
    [_starRateView setValue:[rate floatValue]];
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
