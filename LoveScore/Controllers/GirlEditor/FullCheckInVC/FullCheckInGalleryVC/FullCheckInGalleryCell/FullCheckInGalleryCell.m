//
//  FullCheckInGalleryCell.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/21/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FullCheckInGalleryCell.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIImageEffects.h"

@interface FullCheckInGalleryCell ()
@property (strong, nonatomic) IBOutlet UIButton *starButton;

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *maskImageView;

@property (strong, nonatomic) IBOutlet UIView *blurContainerView;

@property (strong, nonatomic) UIVisualEffectView *blurEffectView;

@end

@implementation FullCheckInGalleryCell

- (void)prepareForReuse {
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - buttons action

- (IBAction)starButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(starButtonAction)]) {
        [self.delegate starButtonAction];
    }
}

- (IBAction)galleryButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(galleryButtonAction)]) {
        [self.delegate galleryButtonAction];
    }
}

#pragma mark - Public methods

- (void)setPhotoImage:(UIImage *)photoImage {
    
    _photoImage = photoImage;
    [self.photoImageView setImage:photoImage];
    
    UIImage *bluredIMage = [UIImageEffects imageByApplyingDarkEffectToImage:photoImage];
    [self.maskImageView setImage:bluredIMage];
}

- (void)showMask {
    [self.blurContainerView setHidden:NO];
}

- (void)hideMask {
    [self.blurContainerView setHidden:YES];
}

- (void)selectedStar {
    [self.starButton setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
}

- (void)deselectedStar {
    [self.starButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
}

#pragma mark - Private methods

- (void)setupAddButton {
    [self.photoImageView setImage:[UIImage imageNamed:@"edit-gallery-add"]];
  }



@end
