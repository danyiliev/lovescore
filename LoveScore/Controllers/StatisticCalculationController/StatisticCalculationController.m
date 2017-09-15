//
//  StatisticCalculationController.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/13/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "StatisticCalculationController.h"
#import "Statistic.h"
#import "Person.h"
#import "CoreDataManager.h"


@interface StatisticCalculationController()


@property (nonatomic, strong) NSMutableDictionary *statistics;
@property (nonatomic, strong) NSArray *allContKeys;

@end

@implementation StatisticCalculationController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)calculateUniqueCountries {
    self.uniqueCountries = [NSMutableSet new];
    id kissDate;
    id loveDate;
    
    for (Person *person in self.girls) {
        if (person.nationality && ![person.nationality isEqualToString:@""]) {
            kissDate = [person.events objectForKey:@"KISS"];
            loveDate = [person.events objectForKey:@"LOVE"];
            
            if (kissDate || loveDate) {
                [self.uniqueCountries addObject:person.nationality];
            }
        }
    }
}

- (Statistic *)getStatisticForCountry:(NSString *)country {
    Statistic *stats = [Statistic new];
    id kissDate;
    id loveDate;
    float rate = 0.0f;
    
    for (Person *person in self.girls) {
        
        if ([person.nationality isEqualToString:country]) {
            if (person.events.count > 0) {
                kissDate = [person.events objectForKey:@"KISS"];
                loveDate = [person.events objectForKey:@"LOVE"];
            }
            
            stats.numberOfGirls++;
            
            if (loveDate) {
                stats.numberOfGirlsWithLoveEvent++;
            }
            if (kissDate && !loveDate) {
                stats.numberOfGirlsWithKissEvent++;
            }
            
            rate += [person.rating floatValue];
        }
    }
    
    stats.averageRating = rate / stats.numberOfGirls;
    stats.numberOfUniqueCountriesWithKissEvent = stats.numberOfGirlsWithKissEvent != 0 ? 1 : 0;
    stats.numberOfUniqueCountriesWithLoveEvent = stats.numberOfGirlsWithLoveEvent != 0 ? 1 : 0;
    
    return stats;
}



- (void)calculateStatisticForCountries {
    
    self.statistics = [NSMutableDictionary new];
    
    NSArray *allContinentsKeys = self.allContKeys;
        
    NSInteger loveNumber = 0;
    NSInteger kissNumber = 0;
    NSInteger countriesLoveNumber = 0;
    NSInteger countriesKissNumber = 0;
    CGFloat rateNumber = 0;
    for (NSString *continent in allContinentsKeys) {
        NSInteger countriesCount = 0;

        loveNumber = 0;
        kissNumber = 0;
        countriesLoveNumber = 0;
        countriesKissNumber = 0;
        rateNumber = 0;

        for (NSString *country in self.uniqueCountries) {
            
            if ([[self.dataStore.countries objectForKey:continent] containsObject:country]) {
                
                if(self.countriesByContinent[continent]) {
                    [self.countriesByContinent[continent] addObject:country];
                } else {
                    self.countriesByContinent[continent] = [@[country] mutableCopy];
                }
                [self.countriesByContinent[@"WD"] addObject:country];

                Statistic *statisctic = [self getStatisticForCountry:country];

                countriesCount++;
                loveNumber += statisctic.numberOfGirlsWithLoveEvent;
                kissNumber += statisctic.numberOfGirlsWithKissEvent;
                countriesKissNumber += statisctic.numberOfUniqueCountriesWithKissEvent;
                countriesLoveNumber += statisctic.numberOfUniqueCountriesWithLoveEvent;
                rateNumber += statisctic.averageRating;
            }
        }

        rateNumber /= countriesCount;

        Statistic *statisctic = [Statistic new];
        statisctic.numberOfGirls = countriesCount;
        statisctic.numberOfGirlsWithLoveEvent = loveNumber;
        statisctic.numberOfGirlsWithKissEvent = kissNumber;
        statisctic.numberOfUniqueCountriesWithKissEvent = countriesKissNumber;
        statisctic.numberOfUniqueCountriesWithLoveEvent = countriesLoveNumber;
        statisctic.averageRating = rateNumber;

        if (countriesCount > 0) {
            [self.statistics setObject:statisctic forKey:continent];
        }
    }
    [self.statistics setObject:[self getStatisticForWorld] forKey:@"WD"];
    [self.statistics setObject:[self getStatisticForUSA] forKey:@"US"];
}

- (Statistic *)getStatisticForWorld {
    Statistic *stats = [Statistic new];
    NSMutableSet *countriesWithKiss = [NSMutableSet set];
    NSMutableSet *countriesWithLove = [NSMutableSet set];
    id kissDate;
    id loveDate;
    float rate = 0.0f;
    
    for (Person *person in self.girls) {
        if (person.events.count > 0) {
            kissDate = [person.events objectForKey:@"KISS"];
            loveDate = [person.events objectForKey:@"LOVE"];
        }
        
        stats.numberOfGirls++;
        
        if (loveDate) {
            stats.numberOfGirlsWithLoveEvent++;
            [countriesWithLove addObject:person.nationality];
        }
        if (kissDate && !loveDate) {
            stats.numberOfGirlsWithKissEvent++;
            [countriesWithKiss addObject:person.nationality];
        }
        
        rate += [person.rating floatValue];
        
    }
    
    stats.averageRating = rate / stats.numberOfGirls;
    stats.numberOfUniqueCountriesWithLoveEvent = [countriesWithLove count];
    stats.numberOfUniqueCountriesWithKissEvent = [countriesWithKiss count];
    
    return stats;
    
}

- (Statistic *)getStatisticForUSA {
    
    Statistic *stats = [Statistic new];
    NSMutableSet *countriesWithKiss = [NSMutableSet set];
    NSMutableSet *countriesWithLove = [NSMutableSet set];
    id kissDate;
    id loveDate;
    float rate = 0.0f;
    
    for (Person *person in self.girls) {
        if (person.state) {
            stats.numberOfGirls++;
            
            if (person.events.count > 0) {
                kissDate = [person.events objectForKey:@"KISS"];
                loveDate = [person.events objectForKey:@"LOVE"];
            }
            
            if (loveDate) {
                stats.numberOfGirlsWithLoveEvent++;
                [countriesWithLove addObject:person.nationality];
            }
            if (kissDate && !loveDate) {
                stats.numberOfGirlsWithKissEvent++;
                [countriesWithKiss addObject:person.nationality];
            }
            
            rate += [person.rating floatValue];
        }
        
    }
    
    stats.averageRating = rate / stats.numberOfGirls;
    stats.numberOfUniqueCountriesWithLoveEvent = [countriesWithLove count];
    stats.numberOfUniqueCountriesWithKissEvent = [countriesWithKiss count];
    
    return stats;
    
    
}

- (void)calculateUniqueStates {
    self.uniqueStates = [NSMutableSet new];
    id kissDate;
    id loveDate;
    
    for (Person *person in self.girls) {
        
        if (person.state && ![person.state isEqualToString:@""]) {
            
            kissDate = [person.events objectForKey:@"KISS"];
            loveDate = [person.events objectForKey:@"LOVE"];
            
            if (kissDate || loveDate) {
                [self.uniqueStates addObject:person.state];
                [self.countriesByContinent[@"US"] addObject:self.dataStore.states[person.state]];
            }
        }
    }
    
}

- (NSMutableDictionary *)getStatistic {
    _countriesByContinent = [NSMutableDictionary new];
    _countriesByContinent[@"US"] = [NSMutableArray new];
    _countriesByContinent[@"WD"] = [NSMutableArray new];
    _girls = [[CoreDataManager instance] getGirlsFromDataBase];
    _dataStore = [[CoreDataManager instance] getDataStore];
    _allContKeys = @[@"WD", @"US", @"EU", @"NA", @"SA",  @"AF", @"AS", @"OC"];
    
    [self calculateUniqueCountries];
    [self calculateUniqueStates];
    [self calculateStatisticForCountries];
    return self.statistics;
}


@end
