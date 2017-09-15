//
//  StatisticCalculationController.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/13/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStore.h"

@interface StatisticCalculationController : NSObject

@property (nonatomic, strong) NSArray *girls;
@property (nonatomic, strong) DataStore *dataStore;
@property (nonatomic, strong) NSMutableSet *uniqueCountries;
@property (nonatomic, strong)NSMutableSet *uniqueStates;

@property (nonatomic, strong) NSMutableDictionary *countriesByContinent;

- (instancetype)init;
- (NSMutableDictionary *)statistics;

- (NSMutableDictionary *)getStatistic;

@end
