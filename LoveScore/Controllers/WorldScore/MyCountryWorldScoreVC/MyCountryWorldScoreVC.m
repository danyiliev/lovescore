//
//  MyCountryWorldScoreVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "MyCountryWorldScoreVC.h"
#import "MyCountryWorldScoreCell.h"
#import "MyCountryWorldScoreHeaderView.h"
#import "UIView+ViewCreator.h"
#import "CoreDataManager.h"
#import "UserEntity.h"
#import "User.h"
#import "Person.h"
#import "DataStoreEntity.h"
#import "Statistic.h"
#import "MyGirlsVC.h"
#import "WorldScoreVC.h"

@interface MyCountryWorldScoreVC ()

@property (strong, nonatomic)MyCountryWorldScoreHeaderView *headerView;
@property (strong, nonatomic)NSDictionary *countriesDictionary;
@property (strong, nonatomic)NSString *country;
@property (strong, nonatomic)NSMutableSet *uniqueCities;
@property (strong, nonatomic)NSMutableArray *girlsFromUserCountries;
@property (strong, nonatomic)NSMutableDictionary *cityStatistic;
@property (strong, nonatomic)NSIndexPath *selectedIndexPath;

@end

@implementation MyCountryWorldScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    self.countriesDictionary = [self getCountriesDictionaryFromDataBase];
    [self calculateStatisticForCountry];
    [self setupTableView];
    [self setupHeaderView];
    [self calculateUniqueCities];
    [self calculateStatisticForCities];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityStatistic.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCountryWorldScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCountryWorldScoreCell class])];
    NSArray *cities = [self.cityStatistic allKeys];
    Statistic *statistic = [self.cityStatistic objectForKey:[cities objectAtIndex:indexPath.row]];
    NSString *city = [cities objectAtIndex:indexPath.row];
    [cell setCityName:city];
    [cell setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithLoveEvent] kissEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithKissEvent] averageRating:[NSNumber numberWithFloat:statistic.averageRating]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"MyCountryVC@MyGirlsVC" sender:self];
}

#pragma mark - Private methods

- (void)setupTableView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCountryWorldScoreCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([MyCountryWorldScoreCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}

- (NSString *)getUserCountry {
    return [[CoreDataManager instance] getUser].country;
}

- (Statistic *)calculateStatisticForCountry {
    self.girlsFromUserCountries = [NSMutableArray new];
    NSString *country = [self getUserCountry];
    self.country = country;
    Statistic *statistic = [Statistic new];
    id kissDate;
    id loveDate;
    float rate = 0.0f;
    
    for (Person *person in self.girls) {
        if ([person.country isEqualToString:country]) {
            [self.girlsFromUserCountries addObject:person];
            statistic.numberOfGirls++;
            
            if (person.events.count > 0) {
                kissDate = [person.events objectForKey:@"KISS"];
                loveDate = [person.events objectForKey:@"LOVE"];
            }
            
            if (loveDate) {
                statistic.numberOfGirlsWithLoveEvent++;
            }
            if (kissDate && !loveDate) {
                statistic.numberOfGirlsWithKissEvent++;
            }
            rate += [person.rating floatValue];
        }
        
    }
    statistic.averageRating = rate / statistic.numberOfGirls;
    
    return statistic;
}

- (NSDictionary *)getCountriesDictionaryFromDataBase {
    DataStore *dataStore = [[CoreDataManager instance] getDataStore];
    NSDictionary *countryDict = [dataStore.internationalisation objectForKey:@"countries"];
    return countryDict;
}

- (void)setupHeaderView {
    self.headerView = [MyCountryWorldScoreHeaderView createView];
    [_tableView setTableHeaderView:self.headerView];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHeader:)];
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.headerView addGestureRecognizer:singleTapRecognizer];
    
    Statistic *statistic = [self calculateStatisticForCountry];
    [self.headerView setFlagImageByCountryName:self.country];
    [self.headerView setCountryName:[self.countriesDictionary objectForKey:self.country]];
    [self.headerView setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithLoveEvent] kissEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithKissEvent] averageRating:[NSNumber numberWithFloat:statistic.averageRating]];
}

- (void)didTapHeader:(UIGestureRecognizer *)recognizer
{
    self.selectedIndexPath = nil;
    [self performSegueWithIdentifier:@"MyCountryVC@MyGirlsVC" sender:self];
}

- (Statistic *)numberOfGirlsFromCity:(NSString *)city {
    Statistic *stats = [Statistic new];
    id kissDate;
    id loveDate;
    NSString *cityName;
    float rate = 0.0f;
    for (Person *person in self.girlsFromUserCountries) {
        if (![[person.city objectForKey:@"name"] isEqual:[NSNull null]]) {
            cityName = [person.city objectForKey:@"name"];
        } else {
            cityName = nil;
        }
        if (cityName && [cityName isEqualToString:city]) {
            stats.numberOfGirls++;
            
            kissDate = [person.events objectForKey:@"KISS"];
            loveDate = [person.events objectForKey:@"LOVE"];
            
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

- (void)calculateStatisticForCities {
    self.cityStatistic = [NSMutableDictionary new];
    for (NSString *city in self.uniqueCities) {
        [self.cityStatistic setObject:[self numberOfGirlsFromCity:city] forKey:city];
    }
}


- (void)calculateUniqueCities {
    self.uniqueCities = [NSMutableSet new];
    NSString *cityName;
    id kissDate;
    id loveDate;
    for (Person *person in self.girlsFromUserCountries) {
        kissDate = [person.events objectForKey:@"KISS"];
        loveDate = [person.events objectForKey:@"LOVE"];
        
        if (kissDate || loveDate) {
            if (![[person.city objectForKey:@"name"] isEqual:[NSNull null]]) {
                cityName = [person.city objectForKey:@"name"];
            } else {
                cityName = nil;
            }
            if (cityName) {
                [self.uniqueCities addObject:cityName];
            }
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MyCountryVC@MyGirlsVC"]) {
        NSMutableArray *girls = [NSMutableArray new];
        NSArray *cities = [self.uniqueCities allObjects];
        for (Person *person in self.girlsFromUserCountries) {
            id kissDate = [person.events objectForKey:@"KISS"];
            id loveDate = [person.events objectForKey:@"LOVE"];
            
            if(self.selectedIndexPath) {
                if (![[person.city objectForKey:@"name"] isEqual:[NSNull null]]) {
                    if ([[person.city objectForKey:@"name"] isEqualToString:[cities objectAtIndex:self.selectedIndexPath.row]] && (kissDate || loveDate)) {
                        [girls addObject:person];
                    }
                }
            } else {
                if (kissDate || loveDate) {
                    [girls addObject:person];
                }
            }
        }
        MyGirlsVC *viewController = [segue destinationViewController];
        viewController.girls = girls;
        viewController.isFiltered = YES;
        viewController.titleString = self.selectedIndexPath ? [cities objectAtIndex:self.selectedIndexPath.row] : [self.countriesDictionary objectForKey:self.country];
    }
}

@end
