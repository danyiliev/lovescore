//
//  HairColorCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "RoundRateView.h"

@interface HairColorCell : UITableViewCell
@property (nonatomic)CellColor cellColor;
@property (weak, nonatomic) IBOutlet RoundRateView *rateView;

- (void)setCellColor:(CellColor)cellColor;
- (void)setHairColorImageWithString:(NSString *)hairColorString;
- (void)setHairColorText:(NSString *)hairColor;
- (void)setNumberOfGirls:(NSInteger)numberOfGirls;
- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating;

@end
