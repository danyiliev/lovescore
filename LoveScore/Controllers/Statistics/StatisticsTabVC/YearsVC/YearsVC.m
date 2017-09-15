//
//  YearsVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "YearsVC.h"
#import "YearsCell.h"
#import "UINavigationItem+CustomBackButton.h"
#import "Person.h"
#import "PersonEntity.h"
#import "CoreDataManager.h"
#import "Statistic.h"
#import "MyGirlsVC.h"

@interface YearsVC ()

@property (nonatomic, strong)NSArray *girls;
@property (nonatomic, strong)NSMutableSet *uniqueYears;
@property (nonatomic, strong)NSMutableDictionary *statistics;
@property (nonatomic, strong)NSArray *sortedYears;
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;

@end

@implementation YearsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    [self calculateUniqueYears];
    [self calculateStatisticForYears];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
    self.sortedYears = [self.uniqueYears sortedArrayUsingDescriptors:sortDescriptors];
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
    return self.uniqueYears.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YearsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YearsCell class])];
    [cell setCellColor:indexPath.row % 2];
    [cell setYear:[self.sortedYears objectAtIndex:indexPath.row]];
    Statistic *statisc = [self.statistics objectForKey:[self.sortedYears objectAtIndex:indexPath.row]];
    [cell setCountOfGirls:statisc.numberOfGirls];
    [cell setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:statisc.numberOfGirlsWithLoveEvent]
                              kissEvent:[NSNumber numberWithInteger:statisc.numberOfGirlsWithKissEvent]
                          averageRating:[NSNumber numberWithInteger:statisc.averageRating]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"YearsVC@MyGirlsVC" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"YearsVC@MyGirlsVC"]) {
        MyGirlsVC *viewController = [segue destinationViewController];
        viewController.girls = [self getGirlsFromDate:self.sortedYears[self.selectedIndexPath.row]];
        viewController.titleString = self.sortedYears[self.selectedIndexPath.row];
        viewController.isFiltered = YES;
    }
}

#pragma mark - Private methods

- (NSArray *)getGirlsFromDate:(NSString *)date {
    NSMutableArray *girls = [NSMutableArray new];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY"];
    for (Person *person in self.girls) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateDate = [dateFormatter dateFromString:[person.events objectForKey:@"DATE"]];
        NSDate *kissDate = [dateFormatter dateFromString:[person.events objectForKey:@"KISS"]];
        NSDate *loveDate = [dateFormatter dateFromString:[person.events objectForKey:@"LOVE"]];
        [dateFormatter setDateFormat:@"YYYY"];
        NSString *dateStr = [dateFormatter stringFromDate:dateDate];
        NSString *kissStr = [dateFormatter stringFromDate:kissDate];
        NSString *loveStr = [dateFormatter stringFromDate:loveDate];
        
        if ([dateStr isEqualToString:date] || [kissStr isEqualToString:date] || [loveStr isEqualToString:date]) {
            if (kissDate || loveDate) {
                [girls addObject:person];
            }
        }
        
    }
    
    
    return girls;
}

- (void)setupTableView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YearsCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([YearsCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}

- (void)calculateUniqueYears {
    self.uniqueYears = [NSMutableSet new];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateDate;
    NSDate *kissDate;
    NSDate *loveDate;
    NSDate *date;
    for (Person *person in self.girls) {
        if (person.events.count > 0) {
            dateDate = [formater dateFromString:[person.events objectForKey:@"DATE"]];
            kissDate = [formater dateFromString:[person.events objectForKey:@"KISS"]];
            loveDate = [formater dateFromString:[person.events objectForKey:@"LOVE"]];
        }
        if (loveDate) {
            NSString *dateStr = [person.events objectForKey:@"LOVE"];
            date = [formater dateFromString:dateStr];
            [formater setDateFormat:@"YYYY"];
            NSString *year = [formater stringFromDate:date];
            if (date) {
           [self.uniqueYears addObject:year];
            }
        }
        [formater setDateFormat:@"YYYY-MM-dd"];
        if (kissDate) {
            NSString *dateStr = [person.events objectForKey:@"KISS"];
            date = [formater dateFromString:dateStr];
            [formater setDateFormat:@"YYYY"];
            NSString *year = [formater stringFromDate:date];
            if (date) {
            [self.uniqueYears addObject:year];
            }
        }
        [formater setDateFormat:@"YYYY-MM-dd"];
        if (dateDate) {
            NSString *dateStr = [person.events objectForKey:@"DATE"];
            date = [formater dateFromString:dateStr];
            [formater setDateFormat:@"YYYY"];
            NSString *year = [formater stringFromDate:date];
            if (date) {
            [self.uniqueYears addObject:year];
            }
        }
    }
}

- (Statistic *)numberOfGirlsFromYear:(NSString *)year {
    Statistic *stats = [Statistic new];
    stats.numberOfGirls = 0;
    stats.numberOfGirlsWithKissEvent = 0;
    stats.numberOfGirlsWithLoveEvent = 0;
    float rate = 0.0f;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-dd"];
    NSDate *loveDate;
    NSDate *kissDate;

    for (Person *person in self.girls) {
        loveDate = [formater dateFromString:[person.events objectForKey:@"LOVE"]];
        kissDate = [formater dateFromString:[person.events objectForKey:@"KISS"]];
        
        if ([[[person.events objectForKey:@"DATE"] substringToIndex:4] isEqualToString:year] || [[[person.events objectForKey:@"KISS"] substringToIndex:4] isEqualToString:year] || [[[person.events objectForKey:@"LOVE"] substringToIndex:4] isEqualToString:year]) {
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

- (void)calculateStatisticForYears {
    self.statistics = [NSMutableDictionary new];
    for (NSString *year in self.uniqueYears) {
        [self.statistics setObject:[self numberOfGirlsFromYear:year] forKey:year];
    }
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
