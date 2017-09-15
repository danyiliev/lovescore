//
//  Statistic.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 12/29/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Statistic : NSObject

@property (nonatomic) NSInteger numberOfGirls;
@property (nonatomic) NSInteger numberOfUniqueCountriesWithKissEvent;
@property (nonatomic) NSInteger numberOfGirlsWithKissEvent;
@property (nonatomic) NSInteger numberOfUniqueCountriesWithLoveEvent;
@property (nonatomic) NSInteger numberOfGirlsWithLoveEvent;
@property (nonatomic) float averageRating;

@end
