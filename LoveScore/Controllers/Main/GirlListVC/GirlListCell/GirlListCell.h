//
//  GirlListCell.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/13/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Global.h"
#import "SWTableViewCell.h"
#import "RoundRateView.h"

#define GirlListCellId @"GirlListCell"

@class GirlListCell;


@interface GirlListCell : SWTableViewCell {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *swipeCellView;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (nonatomic) CellColor girlListCellColor;
@property (nonatomic) SWCellState cellState;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;

- (void)setName:(NSString *)name surname:(NSString *)surname;
- (void)setPhoto:(UIImage *)photoString;
- (void)setIconForEvent:(NSDictionary *)eventsDictionary;
- (void)setFlag:(NSString *)flagString;
- (void)setAge:(NSString *)age country:(NSString *)country city:(NSString *)city;
- (void)setRate:(NSNumber *)rate;

- (void)loadImageWithPhotoUUID:(NSString *)photoUUID;

@end
