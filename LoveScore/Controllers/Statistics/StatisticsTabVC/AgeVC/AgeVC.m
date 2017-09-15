//
//  AgeVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "AgeVC.h"
#import "AgeCell.h"
#import "UINavigationItem+CustomBackButton.h"
#import "CoreDataManager.h"
#import "Person.h"
#import "PersonEntity.h"
#import "Statistic.h"
#import "MyGirlsVC.h"


@interface AgeVC ()

@property (strong, nonatomic)NSArray *titlesForRows;
@property (strong, nonatomic)NSArray *girls;
@property (strong, nonatomic)NSMutableDictionary *statistics;
@property (strong, nonatomic)NSIndexPath *selectedIndexPath;

@end

@implementation AgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.titlesForRows = [NSArray arrayWithObjects:@"18-20", @"20-29", @"30-39", @"40-49", @"50-59", nil];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    [self calculateStatistic];
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
    return self.titlesForRows.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AgeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AgeCell class])];
    [cell setCellColor:indexPath.row % 2];
    [cell setAgeRange:[self.titlesForRows objectAtIndex:indexPath.row]];
    Statistic *stat = [self.statistics objectForKey:[self.titlesForRows objectAtIndex:indexPath.row]];
    [cell setNumberOfGirls:stat.numberOfGirls];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:stat.numberOfGirlsWithLoveEvent]
                              kissEvent:[NSNumber numberWithInteger:stat.numberOfGirlsWithKissEvent]
                          averageRating:[NSNumber numberWithFloat:stat.averageRating]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"AgeVC@MyGirlsVC" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AgeVC@MyGirlsVC"]) {
        MyGirlsVC *viewController = [segue destinationViewController];
        viewController.girls = [self getGirlsWithAgeRange:self.selectedIndexPath.row];
        viewController.titleString = [self.titlesForRows objectAtIndex:self.selectedIndexPath.row];
        viewController.isFiltered = YES;
    }
}

#pragma mark - Private methods
- (NSArray *)getGirlsWithAgeRange:(AgeRanges)ageRange {
    NSMutableArray *girls = [NSMutableArray new];
    NSInteger minAge = 0;
    NSInteger maxAge = 0;
    switch (ageRange) {
        case between18And20:{
            minAge = 18;
            maxAge = 20;
        }
            break;
        case between20And30:{
            minAge = 20;
            maxAge = 30;
        }
            break;
        case between30And40:{
            minAge = 30;
            maxAge = 40;
        }
            break;
        case between40And50:{
            minAge = 40;
            minAge = 50;
        }
            break;
        case moreThen50:{
            minAge = 50;
            maxAge = 100;
        }
            break;
    }
    id kissDate;
    id loveDate;
    
    for (Person *person in self.girls) {
        if ([person.age integerValue] >= minAge && [person.age integerValue] < maxAge) {
            
            kissDate = [person.events objectForKey:@"KISS"];
            loveDate = [person.events objectForKey:@"LOVE"];
            
            if (kissDate || loveDate) {
                [girls addObject:person];
            }
        }
    }
    
    
    return girls;
}

- (Statistic *)numberOfGirlsWithAgeBetween:(NSInteger)minAge and:(NSInteger)maxAge {
    Statistic *stats = [Statistic new];
    float rate = 0.0f;
    id loveDate;
    id kissDate;
    for (Person *person in self.girls) {
        
        if ([person.age integerValue] >= minAge && [person.age integerValue] < maxAge) {
            
            if (person.events.count > 0) {
                loveDate = [person.events objectForKey:@"LOVE"];
                kissDate = [person.events objectForKey:@"KISS"];
            }
            
            if (kissDate || loveDate) {
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

- (void)setupTableView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AgeCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([AgeCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}

- (void)calculateStatistic {
    self.statistics = [NSMutableDictionary new];
    [self.statistics setObject:[self numberOfGirlsWithAgeBetween:18 and:20] forKey:@"18-20"];
    [self.statistics setObject:[self numberOfGirlsWithAgeBetween:20 and:30] forKey:@"20-29"];
    [self.statistics setObject:[self numberOfGirlsWithAgeBetween:30 and:40] forKey:@"30-39"];
    [self.statistics setObject:[self numberOfGirlsWithAgeBetween:40 and:50] forKey:@"40-49"];
    [self.statistics setObject:[self numberOfGirlsWithAgeBetween:50 and:100] forKey:@"50-59"];
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
