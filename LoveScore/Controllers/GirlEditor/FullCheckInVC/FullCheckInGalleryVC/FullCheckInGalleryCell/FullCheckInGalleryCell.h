//
//  FullCheckInGalleryCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/21/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FullCheckInGalleryCellId @"FullCheckInGalleryCellId"

@protocol FullCheckInGalleryCellDelegate <NSObject>

- (void)starButtonAction;
- (void)galleryButtonAction;

@end


@interface FullCheckInGalleryCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, weak) id<FullCheckInGalleryCellDelegate> delegate;


- (void)setupAddButton;

- (void)showMask;
- (void)hideMask;

- (void)selectedStar;
- (void)deselectedStar;

@end
