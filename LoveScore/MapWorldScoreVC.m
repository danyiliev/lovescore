//
//  MapWorldScoreVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "MapWorldScoreVC.h"
#import "MapWorldScoreCell.h"
#import "MapWorldScoreHeaderView.h"
#import "CoreDataManager.h"
#import "DataStoreEntity.h"
#import "Person.h"
#import "MyGirlsVC.h"
#import "Statistic.h"
#import "NetworkActivityIndicator.h"
#import "StatisticCalculationController.h"
#import "User.h"
#import "MapWorldScoreHamburgerCell.h"
#import "UIView+ViewCreator.h"

@interface MapWorldScoreVC () <MapWorldScoreHeaderView, MapWorldScoreHamburgerCell>

@property (weak, nonatomic) IBOutlet UIView *containreMapView;
@property (nonatomic, strong)StatisticCalculationController *statisticController;
@property (nonatomic, strong) CAShapeLayer *oldClickedLayer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mapLoadingIndicator;

@property (strong, nonatomic)NSDictionary *continentsDictionary;

@property (nonatomic, strong) NSMutableSet *uniqueCountries;

@property (nonatomic, assign)NSInteger selectedSection;
@property (nonatomic, strong)NSString *selecterHeaderTitle;
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) NSString *selectedContinentMapName;
@property (nonatomic, strong) NSMutableDictionary *statistics;
@property (nonatomic, strong) NSDictionary *countriesDictionary;
@property (nonatomic, strong) NSDictionary *mapNames;
@property (nonatomic, strong) NSArray *allContKeys;
@property (nonatomic, strong) NSString *selectedCountry;
@property (nonatomic, strong) NSArray *continentsNamesArray;

@property (nonatomic, assign) CGFloat mapX;

@property (nonatomic, strong) NSMutableDictionary *colorData;
@property (nonatomic, strong) NSMutableArray *scoredCountries;
@end

@implementation MapWorldScoreVC
{
    NSInteger _numberOfCols;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _numberOfCols = ((int)(self.view.frame.size.width - 10))/40;
    
    self.mapX = 0;
    self.scoredCountries = [NSMutableArray new];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MapWorldScoreHamburgerCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([MapWorldScoreHamburgerCell class])];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    self.selectedSection = -1;
    
    User *user = [[CoreDataManager instance] getUser];
    if(user && [user.country isEqualToString:@"US"]) {
        self.allContKeys = @[@"US", @"WD", @"EU", @"NA", @"SA",  @"AF", @"AS", @"OC"];
        self.colorData  = [[NSMutableDictionary alloc] init];
        self.continentsNamesArray = @[@"U.S.", @"WORLD",  @"EUROPE", @"NORTH AMERICA", @"SOUTH AMERICA", @"AFRICA", @"ASIA", @"OCEANIA"];
        _continents = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"worldscore-world-icon" , @"WORLD",
                       @"united_states", @"U.S.",
                       @"europe_ws", @"EUROPE",
                       @"north_america", @"NORTH AMERICA",
                       @"south_america", @"SOUTH AMERICA",
                       @"africa", @"AFRICA",
                       @"asia", @"ASIA",
                       @"australia_ws", @"OCEANIA", nil];
    } else {
        self.allContKeys = @[@"WD", @"EU", @"NA", @"SA",  @"AF", @"AS", @"OC"];
        self.colorData  = [[NSMutableDictionary alloc] init];
        self.continentsNamesArray = @[@"WORLD", @"EUROPE", @"NORTH AMERICA", @"SOUTH AMERICA", @"AFRICA", @"ASIA", @"OCEANIA"];
        _continents = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"worldscore-world-icon" , @"WORLD",
                       @"europe_ws", @"EUROPE",
                       @"north_america", @"NORTH AMERICA",
                       @"south_america", @"SOUTH AMERICA",
                       @"africa", @"AFRICA",
                       @"asia", @"ASIA",
                       @"australia_ws", @"OCEANIA", nil];
    }
    
    self.selectedContinentMapName = self.allContKeys[0];
    
    self.statisticController = [[StatisticCalculationController alloc] init];
    
    
    [self.mapLoadingIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.statistics = [self.statisticController getStatistic];
        self.countriesDictionary = [self.statisticController.dataStore.internationalisation objectForKey:@"countries"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupMapView];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allContKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if (self.selectedSection == section) {
        NSString *key = self.allContKeys[section];
        return [self.statisticController.countriesByContinent[key] count] > 0 ? 1 : 0;
    }
    return numberOfRows;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MapWorldScoreHeaderView *view = [MapWorldScoreHeaderView createView];
    
    NSString *continentKey = [self.continentsNamesArray objectAtIndex:section];
    NSString *key = [self.allContKeys objectAtIndex:section];
    
    Statistic *statisctics = [self.statistics objectForKey: key];
    [view.statisticRateView setLoveRate:[NSNumber numberWithInteger:statisctics.numberOfGirlsWithLoveEvent]
                            inCountries:statisctics.numberOfUniqueCountriesWithLoveEvent];
    
    [view.statisticRateView setKissRate:[NSNumber numberWithInteger:statisctics.numberOfGirlsWithKissEvent]
                            inCountries:statisctics.numberOfUniqueCountriesWithKissEvent];
    
    [view.statisticRateView setFullRate:[NSNumber numberWithFloat:statisctics.averageRating]];
    
    view.photoImageView.image =  [UIImage imageNamed:[_continents objectForKey:continentKey]];
    view.continentNameLbl.text = continentKey;
    [view setCellColor:section % 2];

    view.delegate = self;
    view.index = section;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.allContKeys objectAtIndex:indexPath.section];
    MapWorldScoreHamburgerCell *hamburgerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MapWorldScoreHamburgerCell class])];
    hamburgerCell.delegate = self;
    NSArray *imagesNames = self.statisticController.countriesByContinent[key];
    [hamburgerCell setCountriesNames:imagesNames];
    [hamburgerCell.colectionView reloadData];

    if(indexPath.section % 2 == 1) {
        [hamburgerCell.colectionView setBackgroundColor:[UIColor colorWithRed:243.f / 255.f green:243.f / 255.f blue:243.f / 255.f alpha:1]];
    } else {
        [hamburgerCell.colectionView setBackgroundColor:[UIColor whiteColor]];
    }
    return hamburgerCell;
}

- (void)didSelectHeaderAtIndex:(NSInteger)index {
    if (self.selectedSection == index) {
        self.selectedSection = -1;
        [self.tableView reloadData];
        return;
    } else if ([self.selecterHeaderTitle isEqualToString:self.allContKeys[index]]) {
        self.selectedSection = index;
        [self.tableView reloadData];
        return;
    } else {
        self.selectedSection = index;
        self.selecterHeaderTitle = self.allContKeys[index];
    }
    
    NSString *countryKey = self.allContKeys[index];
    self.selectedContinentMapName = countryKey;
    if ([countryKey isEqualToString:@"EU"]) {
        self.mapX = 20;
    } else if ([countryKey isEqualToString:@"SA"]) {
        self.mapX = 150;
    } else if ([countryKey isEqualToString:@"NA"]) {
        self.mapX = 80;
    } else if ([countryKey isEqualToString:@"AF"]) {
        self.mapX = 100;
    } else if ([countryKey isEqualToString:@"AS"]) {
        self.mapX = 80;
    } else if ([countryKey isEqualToString:@"OC"]) {
        self.mapX = 80;
    } else if ([countryKey isEqualToString:@"WD"]) {
        self.mapX = 0;
    } else if ([countryKey isEqualToString:@"US"]) {
        self.mapX = 0;
    }
    
    [self setupMapView];
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.allContKeys[indexPath.section];
    NSInteger count = [self.statisticController.countriesByContinent[key] count];
    NSInteger one = count % _numberOfCols == 0 ? 0 : 1;
    return 40.0f * ((count / _numberOfCols) + one);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (void)selectCountry:(NSString *)country {
    NSString *key = self.selecterHeaderTitle;
    if ([key isEqualToString:@"US"]) {
        self.selectedCountry = country;
    } else {
        self.selectedCountry = self.countriesDictionary[country];
    }
    [self performSegueWithIdentifier:@"Map@MyGirlsVC" sender:self];
}

- (void)fillMapWithCountries:(BOOL)countries {
    NSArray *countryCodes = [self.statisticController.uniqueCountries allObjects];
    NSArray *stateCodes = [self.statisticController.uniqueStates allObjects];
    
    [self.map enumerateLayersUsingBlock:^(NSString *identifier, CAShapeLayer *layer) {
        NSArray *array = [identifier componentsSeparatedByString:@"-"];
        if ((countries && [countryCodes containsObject:identifier]) || (!countries && [stateCodes containsObject:[array lastObject]])) {
            if (identifier) {
                [self.colorData setObject:RED_COLOR forKey:identifier];
            }
        }
    }];
    [self layoutMap];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MyGirlsVC *viewController = [segue destinationViewController];
    NSString *key = self.selecterHeaderTitle;
    if ([key isEqualToString:@"US"]) {
        viewController.girls = [self getGirlsWithState:self.selectedCountry];
    } else {
        viewController.girls = [self getGirlsWithNationality:self.selectedCountry];
    }
    viewController.titleString = self.selectedCountry;
    viewController.isFiltered = YES;
}

#pragma mark - Private methods

- (NSArray *)getGirlsWithNationality:(NSString *)nationality {
    NSMutableArray *girls = [NSMutableArray new];
    self.girls = self.statisticController.girls;
    for (Person *person in self.girls) {
        if ([[self.countriesDictionary objectForKey:person.nationality] isEqualToString:nationality]) {
            
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
    self.girls = self.statisticController.girls;
    for (Person *person in self.girls) {
        if ([[self.statisticController.dataStore.states objectForKey:person.state] isEqualToString:state]) {
            
            id kissDate = [person.events objectForKey:@"KISS"];
            id loveDate = [person.events objectForKey:@"LOVE"];
            if (kissDate || loveDate) {
                [girls addObject:person];
            }
        }
    }
    return girls;
}

- (void)layoutMap {
    CGRect rect = self.containreMapView.frame;
    rect.origin = CGPointMake(self.mapX, 0);
    _map.frame = rect;
    [_map setFillColor:[UIColor blackColor]];
    [_map setContentMode:UIViewContentModeScaleToFill];
    [_map setColors:self.colorData];
    
    _map.layer.shouldRasterize = YES;
    _map.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)setupMapView {
    CGRect rect = self.containreMapView.frame;
    [_map removeFromSuperview];
    [self.mapLoadingIndicator startAnimating];
    
    rect.origin = CGPointMake(100, 0);
    _map = [[FSInteractiveMapView alloc] initWithFrame:rect];
    self.parentViewController.view.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_map loadMap:self.selectedContinentMapName withColors:self.colorData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.parentViewController.view.userInteractionEnabled = YES;
            [self.mapLoadingIndicator stopAnimating];
            [self fillMapWithCountries:![self.selectedContinentMapName isEqualToString:@"US"]];
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.2 animations:^{
                [_map setAlpha:1];
            } completion:^(BOOL finished) {
                [self.containreMapView addSubview:_map];
            }];
        });
    });
}

@end
