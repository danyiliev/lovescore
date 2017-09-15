//
//  GirlCardCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/15/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GirlCardCellId @"GirlCardCellId"

@interface GirlCardCell : UICollectionViewCell 

- (void)setRate:(NSNumber *)rate;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (strong, nonatomic) NSString *photoPath;
@property (nonatomic, strong) UIImage *photo;

- (void)setFlagImageWithCountryName:(NSString *)countryName;

- (void)loadImageWithPhotoUUID:(NSString *)photoUUID;

@end
