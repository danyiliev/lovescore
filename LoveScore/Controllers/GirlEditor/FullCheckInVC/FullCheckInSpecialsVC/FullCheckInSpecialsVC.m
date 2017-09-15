//
//  FullCheckInSpecialsVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FullCheckInSpecialsVC.h"
#import "SpecialsCellWithSlider.h"
#import "SpecialsCellWithSwitch.h"
#import "UIView+ViewCreator.h"
#import "Global.h"
#import "FullCheckInVC.h"

#import "DataStore.h"
#import "CoreDataManager.h"
#import "DataStoreEntity.h"

@interface FullCheckInSpecialsVC ()<UITableViewDataSource, UITableViewDelegate, SpecialsCellWithSwitchDelegate, SpecialsCellWithSliderDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionNamesArray;
@property (nonatomic, strong) NSArray *physicalNamesArray;
@property (nonatomic, strong) NSArray *valuesNamesArray;
@property (nonatomic, strong) NSArray *skillsNamesArray;
@property (nonatomic, strong) NSArray *attributesNamesArray;
@property (nonatomic, strong) NSDictionary *attributesDictionary;
@property (nonatomic, strong) NSDictionary *personRatingsLocalizationDictionary;

//TODO:finish array which will contain attirbutes
@property (nonatomic, strong) NSMutableDictionary *selectedAttribute;
@property (nonatomic, strong) NSMutableDictionary *personRatingsDictionary;


@end

@implementation FullCheckInSpecialsVC

#pragma mark - System and init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedAttribute = [[NSMutableDictionary alloc]init];
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    self.personRatingsDictionary = [NSMutableDictionary new];
    self.personRatingsLocalizationDictionary = @{@"Butt":@"back",
                                                 @"Loving":@"intercourse",
                                                 @"Playing": @"oral",
                                                 @"Kissing":@"kissing",
                                                 @"Intelligence":@"intelligence",
                                                 @"Character":@"character",
                                                 @"Legs":@"legs",
                                                 @"Hair":@"hair",
                                                 @"Bust":@"bust",
                                                 @"Face":@"face"};
    self.attributesDictionary = @{
                                @"tattoo" : @"Tattoo",
                                @"piercing" : @"Piercing",
                                @"exotic" : @"Exotic",
                                @"vip" : @"Famous",
                                @"gold-digger" : @"Gold Digger",
                                @"phone" : @"Text fun",
                                @"online" : @"Video fun",
                                @"model" : @"Model",
                                @"playmate" : @"Playmate",
                                @"milf" : @"MILF"
                                };
    
    [self setupData];
}

- (NSString *)getKeyForObject:(id)object dictionary:(NSDictionary *)dictionary {
    NSArray *allKeys = [dictionary allKeysForObject:object];
    NSString *key = [allKeys firstObject];
    return key;
}

- (void)viewWillAppear:(BOOL)animated {
    for (NSString *str  in self.person.attributes) {
        [self.selectedAttribute setObject:[NSNumber numberWithBool:YES] forKey:str];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowsInSectionNumber = 0;
    
    switch (section) {
        case 0: {
            rowsInSectionNumber = self.physicalNamesArray.count;
        }
            break;
            
        case 1: {
            rowsInSectionNumber = self.valuesNamesArray.count;
        }
            break;
            
        case 2: {
            rowsInSectionNumber = self.skillsNamesArray.count;
        }
            break;
            
        case 3: {
            rowsInSectionNumber = self.attributesNamesArray.count;
        }
            break;
            
        default:
            break;
    }
    
    return rowsInSectionNumber;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 53.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 53.0)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(8, 17, sectionHeaderView.frame.size.width, 19.0)];
    
    UIFont *font = [UIFont fontWithName:@"Lato-Bold" size:16.0];
    UIColor *textColor = RED_COLOR;
    NSDictionary *textAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:textColor};
    
    NSAttributedString *headerText = [[NSAttributedString alloc] initWithString:[_sectionNamesArray objectAtIndex:section] attributes:textAttributes];
    
    headerLabel.attributedText = headerText;
    [headerLabel sizeToFit];
    
    [sectionHeaderView addSubview:headerLabel];
    
    return  sectionHeaderView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < 3) {
        
        SpecialsCellWithSlider *cell = [tableView dequeueReusableCellWithIdentifier:SpecialsCellWithSliderId];
        
        if (!cell) {
            cell = [SpecialsCellWithSlider createView];
        }
        
        switch (indexPath.section) {
            case 0: {
                NSString *physicalName = _physicalNamesArray[indexPath.row];
                [cell setParameterName:physicalName];
                cell.delegate = self;
                if (self.person.personRatings.count > 0) {
                    [cell setRate:self.person.personRatings[self.personRatingsLocalizationDictionary[physicalName]]];
                }
            }
                break;
            case 1: {
                [cell setParameterName:_valuesNamesArray[indexPath.row]];
                cell.delegate = self;
                
                if (self.person.personRatings.count > 0) {
                    [cell setRate:self.person.personRatings[self.personRatingsLocalizationDictionary[self.valuesNamesArray[indexPath.row]]]];
                }
            }
                break;
            case 2: {
                [cell setParameterName:_skillsNamesArray[indexPath.row]];
                cell.delegate = self;
                if (self.person.personRatings.count > 0) {
                    [cell setRate:self.person.personRatings[self.personRatingsLocalizationDictionary[self.skillsNamesArray[indexPath.row]]]];
                }
            }
                break;
                
            default: {
            }
                break;
        }
        return cell;
    } else {
        
        SpecialsCellWithSwitch *cell = [tableView dequeueReusableCellWithIdentifier:SpecialsCellWithSwitchId];
        
        if (!cell) {
            cell = [SpecialsCellWithSwitch createView];
        }
        
        cell.delegate = self;
        
        [cell setParameterName:[self.attributesDictionary objectForKey:self.attributesNamesArray[indexPath.row]]];
        
        
        if ([self.selectedAttribute objectForKey:self.attributesNamesArray[indexPath.row]]) {
            [cell setIsSwitchTurnOn:YES];
        } else {
            [cell setIsSwitchTurnOn:NO];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Public methods

- (void)savePerson {
    self.person.attributes = self.selectedAttribute.allKeys;
    self.person.personRatings = self.personRatingsDictionary;
}


#pragma mark - Private methods

- (DataStore *)getDataStoreFromDataBase {
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
    
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    
    DataStoreEntity *data = (DataStoreEntity *)lReturn[0];
    DataStore *dataStore = [MTLManagedObjectAdapter modelOfClass:[DataStore class] fromManagedObject:data error:&lError];
    
    if (lError != nil) {
        NSLog(@"%@ %s %@", self.class, __func__, lError.description);
    }
    
    return dataStore;
}

- (void)setupData {
    // setup arrays for sliders
    _sectionNamesArray = [[NSArray alloc]initWithObjects:@"PHYSICAL",@"VALUES", @"SKILLS", @"ATTRIBUTES", nil];
    
    _physicalNamesArray = [[NSArray alloc]initWithObjects:@"Face", @"Hair", @"Bust", @"Butt", @"Legs", nil];
    
    _valuesNamesArray = [[NSArray alloc]initWithObjects:@"Character",@"Intelligence" ,nil];
    
    _skillsNamesArray = [[NSArray alloc]initWithObjects:@"Kissing", @"Playing", @"Loving", nil];
    
    //setup attributes array. Get data from data store
    
    DataStore *dataStore = [self getDataStoreFromDataBase];
    
    self.attributesNamesArray = dataStore.attributes;
    if (self.person.personRatings.count > 0) {
        self.personRatingsDictionary = [[NSMutableDictionary alloc] initWithDictionary:self.person.personRatings];
    }
    
}
#pragma mark - SpecialsCellWithSwitchDelegate

- (void)switchWasTurnOn:(NSString *)parameterName {
    NSString *key = [self getKeyForObject:parameterName dictionary:self.attributesDictionary];
    [self.selectedAttribute setObject:[NSNumber numberWithBool:YES] forKey:key];
}

- (void)switchWasTurnOff:(NSString *)parameterName {
    NSString *key = [self getKeyForObject:parameterName dictionary:self.attributesDictionary];
    [self.selectedAttribute removeObjectForKey:key];
}

#pragma mark - SpecialsCellWithSliderDelegate

- (void)sliderWithName:(NSString *)parameterName WasChangedWithValue:(NSNumber *)value {
    NSString *key = self.personRatingsLocalizationDictionary[parameterName];
    [self.personRatingsDictionary setValue:value forKey:key];
    
    [self savePerson];
}

@end
