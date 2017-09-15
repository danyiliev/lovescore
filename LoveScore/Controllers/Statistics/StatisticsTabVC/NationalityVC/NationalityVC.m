//
//  NationalityVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "NationalityVC.h"
#import "NationalityCell.h"
#import "UINavigationItem+CustomBackButton.h"
#import "Person.h"
#import "PersonEntity.h"
#import "DataStoreEntity.h"
#import "DataStore.h"
#import "CoreDataManager.h"
#import "Statistic.h"
#import "MyGirlsVC.h"

@interface NationalityVC ()

@property (strong, nonatomic)NSArray *girls;
@property (strong, nonatomic)NSMutableSet *uniqueNationalities;
@property (strong, nonatomic)NSDictionary *nationalitiesDictionary;
@property (strong, nonatomic)NSMutableDictionary *statistics;
@property (strong, nonatomic)NSArray *sortedNatianalities;
@property (strong, nonatomic)NSIndexPath *selectedIndexPath;

@end

@implementation NationalityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.hidesBottomBarWhenPushed = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    self.nationalitiesDictionary = [self getNationalitiesFromDataStore];
    [self calculateUniqueNationalities];
    [self calculateStatisticForNationality];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    NSArray *sortDescroptors = [NSArray arrayWithObject:descriptor];
    self.sortedNatianalities = [self.uniqueNationalities sortedArrayUsingDescriptors:sortDescroptors];
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
    
    return self.uniqueNationalities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NationalityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NationalityCell class])];
    [cell setCellColor:indexPath.row % 2];
    
    [cell setNationality:[self getNationalityWithCountryCode:[self.sortedNatianalities objectAtIndex:indexPath.row]]];
    Statistic *statistic = [self.statistics objectForKey:self.sortedNatianalities[indexPath.row]];
    [cell setNumberOfGirls:statistic.numberOfGirls];
    [cell setFlagImageWithCountryName:[self.sortedNatianalities objectAtIndex:indexPath.row]];
    [cell setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithLoveEvent] kissEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithKissEvent] averageRating:[NSNumber numberWithFloat:statistic.averageRating]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"NationalityVC@MyGirlsVC" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NationalityVC@MyGirlsVC"]) {
        
        MyGirlsVC *viewController = [segue destinationViewController];
        viewController.girls = [self getGirlsWithNationality:[self.nationalitiesDictionary objectForKey:[self.sortedNatianalities objectAtIndex:self.selectedIndexPath.row]]];
        viewController.titleString = [self.nationalitiesDictionary objectForKey:[self.sortedNatianalities objectAtIndex:self.selectedIndexPath.row]];
        viewController.isFiltered = YES;
    }
}

#pragma mark - Private method

- (NSMutableArray *)getGirlsWithNationality:(NSString *)nationality {
    NSMutableArray *girls = [NSMutableArray new];
    for (Person *person in self.girls) {
        
        if ([[self.nationalitiesDictionary objectForKey:person.nationality] isEqualToString:nationality]) {
            id kissDate = [person.events objectForKey:@"KISS"];
            id loveDate = [person.events objectForKey:@"LOVE"];
            if (kissDate || loveDate)
                [girls addObject:person];
        }
    }
    
    return girls;
}

- (void)setupTableView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NationalityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([NationalityCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}

- (void)calculateUniqueNationalities {
    self.uniqueNationalities = [NSMutableSet new];
    id kissDate;
    id loveDate;
    
    for (Person *person in self.girls) {
        if (person.nationality && ![person.nationality isEqualToString:@""]) {
            kissDate = [person.events objectForKey:@"KISS"];
            loveDate = [person.events objectForKey:@"LOVE"];
            
            if (kissDate || loveDate) {
                [self.uniqueNationalities addObject:person.nationality];
            }
        }
    }
}

- (void)calculateStatisticForNationality {
    self.statistics = [NSMutableDictionary new];
    for (NSString *nationality in self.uniqueNationalities) {
        [self.statistics setObject:[self numberOfGirlsWithNationality:nationality] forKey:nationality];
    }
}

- (NSDictionary *)getNationalitiesFromDataStore {
    
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    
    DataStoreEntity *data = (DataStoreEntity *)lReturn[0];
    DataStore *dataStore = [MTLManagedObjectAdapter modelOfClass:[DataStore class] fromManagedObject:data error:&lError];
    
    if (lError != nil) {
        NSLog(@"%@ %s %@", self.class, __func__, lError.description);
    }
    
    
    NSDictionary *nationalitiesDictionary = [dataStore.internationalisation objectForKey:@"countries"];
    return nationalitiesDictionary;
}

- (NSString *)getNationalityWithCountryCode:(NSString *)code {
    return [self.nationalitiesDictionary objectForKey:code];
}

- (Statistic *)numberOfGirlsWithNationality:(NSString *)nationality {
    Statistic *stats = [Statistic new];
    float rate = 0.0f;
    id loveDate;
    id kissDate;
    for (Person *person in self.girls) {
        if (person.nationality == nationality) {
            if (person.events.count > 0) {
                loveDate = [person.events objectForKey:@"LOVE"];
                kissDate = [person.events objectForKey:@"KISS"];
            }
            
            if (loveDate || kissDate) {
                stats.numberOfGirls++;
                if (loveDate) {
                    stats.numberOfGirlsWithLoveEvent++;
                } else if (kissDate) {
                    stats.numberOfGirlsWithKissEvent++;
                }
                rate += [person.rating floatValue];
            }
        }
    }
    stats.averageRating = rate / stats.numberOfGirls;
    return stats;
}

#pragma mark - Bar Buttons Actions

-(void)backBarButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
