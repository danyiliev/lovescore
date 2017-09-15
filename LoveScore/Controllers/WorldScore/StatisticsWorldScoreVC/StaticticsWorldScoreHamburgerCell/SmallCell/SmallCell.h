//
//  SmallCell.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/28/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

- (void)setFlagImageWithCountryName:(NSString *)countryName;
- (void)setCountryName:(NSString *)countryName;
- (void)setNumberOfGirlsWithLoveEvent:(NSNumber *)numberWithLoveEvent
                            kissEvent:(NSNumber *)numberWithKissEvent
                        averageRating:(NSNumber *)averageRating;

@end
