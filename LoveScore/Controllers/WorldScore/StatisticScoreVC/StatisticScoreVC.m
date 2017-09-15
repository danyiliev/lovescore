//
//  StatisticScoreVCViewController.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 3/16/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "StatisticScoreVC.h"
#import "SmallCell.h"
#import "StatisticScoreHeaderView.h"
#import "UIView+ViewCreator.h"
#import "DataStoreEntity.h"
#import "CoreDataManager.h"
#import "Statistic.h"
#import "MyGirlsVC.h"
#import "Person.h"
#import "User.h"

@interface StatisticScoreVC () <UITableViewDataSource, UITableViewDelegate, StatisticScoreHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)NSInteger selectedSection;
@property (nonatomic, strong)NSMutableSet *uniqueStates;
@property (nonatomic, strong)NSMutableSet *uniqueCountries;
@property (nonatomic, strong)NSDictionary *countriesDictionary;
@property (nonatomic, strong)NSMutableDictionary *statistics;

@property (nonatomic, strong)NSDictionary *imageNamesDictionary;
@property (nonatomic, strong)NSString *selecterHeaderTitle;
@property (nonatomic, strong)NSDictionary *continetsDictionary;
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableDictionary *currentCountriesCount;

@property (nonatomic, strong) NSArray *continentsArray;

@end

@implementation StatisticScoreVC
{
    NSInteger numberOfCountries;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentCountriesCount = [NSMutableDictionary new];
    
    [self setupTableView];
    
    User *user = [[CoreDataManager instance] getUser];
    if(user && [user.country isEqualToString:@"US"]) {
        self.continentsArray = @[@"US", @"WD", @"EU", @"NA", @"SA", @"AF", @"AS", @"OC"];
        
        self.imageNamesDictionary = @{@"WD" : @"worldscore-world-icon",
                                      @"US" : @"united_states",
                                      @"EU" : @"europe_ws",
                                      @"NA" : @"north_america",
                                      @"SA" : @"south_america",
                                      @"AF" : @"africa",
                                      @"AS" : @"asia",
                                      @"OC" : @"australia_ws"
                                      };
        self.continetsDictionary = @{@"WD" : @"WORLD",
                                     @"US" : @"U.S.",
                                     @"EU" : @"EUROPE",
                                     @"NA" : @"NORTH AMERICA",
                                     @"AF" : @"AFRICA",
                                     @"SA" : @"SOUTH AMERICA",
                                     @"AS" : @"ASIA",
                                     @"OC" : @"OCEANIA"
                                     };
    } else {
        self.continentsArray = @[@"WD", @"EU", @"NA", @"SA", @"AF", @"AS", @"OC"];
        
        self.imageNamesDictionary = @{@"WD" : @"worldscore-world-icon",
                                      @"EU" : @"europe_ws",
                                      @"NA" : @"north_america",
                                      @"SA" : @"south_america",
                                      @"AF" : @"africa",
                                      @"AS" : @"asia",
                                      @"OC" : @"australia_ws"
                                      };
        self.continetsDictionary = @{@"WD" : @"WORLD",
                                     @"EU" : @"EUROPE",
                                     @"NA" : @"NORTH AMERICA",
                                     @"AF" : @"AFRICA",
                                     @"SA" : @"SOUTH AMERICA",
                                     @"AS" : @"ASIA",
                                     @"OC" : @"OCEANIA"
                                     };
    }
    
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    self.dataStore = [[CoreDataManager instance] getDataStore];
    self.countriesDictionary = [self.dataStore.internationalisation objectForKey:@"countries"];
    [self calculateUniqueCountries];
    [self calculateUniqueStates];
    [self calculateStatisticForCountries];
    self.selectedSection = -1;
    [self.dataStore.countries enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        numberOfCountries += [obj count];
    }];
    
    self.tableView.rowHeight = 56;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.continentsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if (self.selectedSection == section) {
        NSDictionary *dict = [self.statistics objectForKey:self.selecterHeaderTitle];
        numberOfRows = dict.count;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmallCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SmallCell class]) forIndexPath:indexPath];
    NSDictionary *dict = [self.statistics objectForKey:self.selecterHeaderTitle];
    NSArray *allValues = [[dict allValues] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSNumber *a = @([(Statistic *)obj1 numberOfGirls]);
        NSNumber *b = @([(Statistic *)obj2 numberOfGirls]);
        return [b compare:a];
    }];
    
    Statistic *statistic = allValues[indexPath.row];
    NSString *key = [[dict allKeysForObject:statistic] firstObject];
    
    if ([self.selecterHeaderTitle isEqualToString:@"US"]) {
        NSString *name = self.dataStore.states[key];
        [cell setCountryName:name];
        [cell setFlagImageWithCountryName:name];
    } else {
        [cell setCountryName:self.countriesDictionary[key]];
        [cell setFlagImageWithCountryName:key];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithLoveEvent] kissEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithKissEvent] averageRating:[NSNumber numberWithFloat:statistic.averageRating]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StatisticScoreHeaderView *view = [StatisticScoreHeaderView createView];
    
    NSString *key = self.continentsArray[section];
    
    NSInteger percents;
    NSInteger counriesCount;
    NSInteger allCountriesCount;
    NSNumber *currentCountriesCount;
    if([key isEqualToString:@"US"]) {
        allCountriesCount = [self.dataStore.states allKeys].count;
        currentCountriesCount = @([self.uniqueStates count]);
    } else if ([key isEqualToString:@"WD"]){
        allCountriesCount = numberOfCountries;
        currentCountriesCount = @([self.uniqueCountries count]);
    } else {
        allCountriesCount = ((NSArray *)[self.dataStore.countries objectForKey:key]).count;
        currentCountriesCount = [self.currentCountriesCount objectForKey:key];
    }
    if (currentCountriesCount) {
        counriesCount = [currentCountriesCount integerValue];
        percents = (counriesCount * 100) / allCountriesCount;
    } else {
        percents = 0;
        counriesCount = 0;
    }
    
    view.photoImageView.image = [UIImage imageNamed:[self.imageNamesDictionary objectForKey:key]];
    
    view.continentNameLbl.text = [self.continetsDictionary objectForKey:key];
    
    [view.progressView setProgressWithPercent:percents];
    
    [view setCountOfGirls:counriesCount numberOfAllGirls:allCountriesCount];
    
    [view setCellColor:section % 2];
    
    view.delegate = self;
    view.index = section;
    return view;
}

- (void)didSelectHeaderAtIndex:(NSInteger)index {
    if (self.selectedSection == index) {
        self.selectedSection = -1;
    } else {
        self.selectedSection = index;
        self.selecterHeaderTitle = self.continentsArray[index];
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 73;
}

- (void)setupTableView {
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SmallCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SmallCell class])];
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
            }
        }
    }
}

- (Statistic *)getStatisticForState:(NSString *)state {
    Statistic *stats = [Statistic new];
    id kissDate;
    id loveDate;
    float rate = 0.0f;
    
    for (Person *person in self.girls) {
        if ([person.state isEqualToString:state]) {
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
    
    return stats;
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
    
    return stats;
}

- (void)calculateStatisticForCountries {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *countriesDictionary;
        self.statistics = [NSMutableDictionary new];
        NSArray *allContinentsKeys = [self.dataStore.countries allKeys];
        NSMutableDictionary *worldDictionary = [NSMutableDictionary new];
        for (NSString *continent in allContinentsKeys) {
            countriesDictionary = [NSMutableDictionary new];
            
            NSInteger countriesCount = 0;
            
            for (NSString *country in self.uniqueCountries) {
                
                if ([[self.dataStore.countries objectForKey:continent] containsObject:country]) {
                    
                    Statistic *statisctic = [self getStatisticForCountry:country];
                    
                    countriesCount++;
                    
                    [countriesDictionary setObject:statisctic forKey:country];
                }
            }
            
            if (countriesCount > 0) {
                [self.currentCountriesCount setObject:@(countriesCount) forKey:continent];
            }
            
            if (countriesDictionary.count != 0) {
                [self.statistics setObject:countriesDictionary forKey:continent];
                [worldDictionary addEntriesFromDictionary:countriesDictionary];
            }
        }
        
        [self.statistics setObject:worldDictionary forKey:@"WD"];
        
        {
            countriesDictionary = [NSMutableDictionary new];
            
            for (NSString *state in self.uniqueStates) {
                
                Statistic *statisctic = [self getStatisticForState:state];
                
                
                [countriesDictionary setObject:statisctic forKey:state];
            }
            
            if (self.uniqueStates.count > 0) {
                [self.currentCountriesCount setObject:@(self.uniqueStates.count) forKey:@"US"];
            }
            
            if (countriesDictionary.count != 0) {
                [self.statistics setObject:countriesDictionary forKey:@"US"];
            }

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"StatisticScoreVC@MyGirlsVC" sender:self];
}

- (NSString *)getKeyByValue:(NSString *)value {
    NSArray *allKeys = [self.continetsDictionary allKeysForObject:value];
    return [allKeys firstObject];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"StatisticScoreVC@MyGirlsVC"]) {
        NSDictionary *dict = [self.statistics objectForKey:self.selecterHeaderTitle];
        NSArray *allKeys = [dict allKeys];
        NSString *country = [allKeys objectAtIndex:self.selectedIndexPath.row];
        
        MyGirlsVC *viewController = [segue destinationViewController];
        NSString *key = self.selecterHeaderTitle;
        if ([key isEqualToString:@"US"]) {
            viewController.girls = [self getGirlsWithState:country];
            viewController.titleString = self.dataStore.states[country];
        } else {
            viewController.girls = [self getGirlsWithNationality:country];
            viewController.titleString = self.countriesDictionary[country];
        }
        viewController.isFiltered = YES;
    }
}

- (NSArray *)getGirlsWithNationality:(NSString *)nationality {
    NSMutableArray *girls = [NSMutableArray new];
    for (Person *person in self.girls) {
        if ([person.nationality isEqualToString:nationality]) {
            
            id kissDate = [person.events objectForKey:@"KISS"];
            id loveDate = [person.events objectForKey:@"LOVE"];
            if (kissDate || loveDate) {
                [girls addObject:person];
            }
        }
    }
    return girls;
}

- (NSArray *)getGirlsWithState:(NSString *)state {
    NSMutableArray *girls = [NSMutableArray new];
    for (Person *person in self.girls) {
        if ([person.state isEqualToString:state]) {
            
            id kissDate = [person.events objectForKey:@"KISS"];
            id loveDate = [person.events objectForKey:@"LOVE"];
            if (kissDate || loveDate) {
                [girls addObject:person];
            }
        }
    }
    return girls;
}

@end
