//
//  MonthsVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "MonthsVC.h"
#import "MonthsCell.h"
#import "UINavigationItem+CustomBackButton.h"
#import "PersonEntity.h"
#import "Person.h"
#import "CoreDataManager.h"
#import "Statistic.h"
#import "MyGirlsVC.h"

@interface MonthsVC ()

@property (strong, nonatomic)NSArray *girls;
@property (strong, nonatomic)NSMutableSet *uniqueDate;
@property (strong, nonatomic)NSMutableDictionary *statistics;
@property (strong, nonatomic)NSArray *sortedDates;
@property (strong, nonatomic)NSIndexPath *selectedIndexPath;

@end

@implementation MonthsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    [self calculateUniqueDates];
    [self calculateStatisticForDates];
    [self sortDates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.uniqueDate.count;
}

#pragma mark Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MonthsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MonthsCell class])];
    [cell setCellColor:indexPath.row % 2];
    NSArray *date = [[self.sortedDates objectAtIndex:indexPath.row] componentsSeparatedByString:@"-"];
    [cell setYear:date[0]];
    [cell setMonth:date[1]];
    Statistic *statistic = [self.statistics objectForKey:self.sortedDates[indexPath.row]];
    [cell setNumberOfGirls:statistic.numberOfGirls];
    [cell setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithLoveEvent] kissEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithKissEvent] averageRating:[NSNumber numberWithFloat:statistic.averageRating]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"MonthVC@MyGirlsVC" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MonthVC@MyGirlsVC"]) {
        MyGirlsVC *viewController = [segue destinationViewController];
        viewController.girls = [self getGirlsFromDate:self.sortedDates[self.selectedIndexPath.row]];
        viewController.titleString = [self.sortedDates objectAtIndex:self.selectedIndexPath.row];
        viewController.isFiltered = YES;
    }
}

#pragma mark - Private methods

- (NSArray *)getGirlsFromDate:(NSString *)date {
    NSMutableArray *girls = [NSMutableArray new];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY-MMMM"];
    for (Person *person in self.girls) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateDate = [dateFormatter dateFromString:[person.events objectForKey:@"DATE"]];
        NSDate *kissDate = [dateFormatter dateFromString:[person.events objectForKey:@"KISS"]];
        NSDate *loveDate = [dateFormatter dateFromString:[person.events objectForKey:@"LOVE"]];
        [dateFormatter setDateFormat:@"YYYY-MMMM"];
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
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MonthsCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([MonthsCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}

- (void)sortDates {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
    self.sortedDates = [self.uniqueDate sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)calculateUniqueDates {
    self.uniqueDate = [NSMutableSet new];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-dd"];
    NSDate *loveDate;
    NSDate *kissDate;
    NSDate *dateDate;
    for (Person *person in self.girls) {
        if (person.events.count > 0) {
            loveDate = [formater dateFromString:[person.events objectForKey:@"LOVE"]];
            kissDate = [formater dateFromString:[person.events objectForKey:@"KISS"]];
            dateDate = [formater dateFromString:[person.events objectForKey:@"DATE"]];
        }
        
        if (loveDate) {
            NSString *dateStr = [person.events objectForKey:@"LOVE"];
            NSDate *date = [formater dateFromString:dateStr];
            [formater setDateFormat:@"YYYY-MMMM"];
            dateStr = [formater stringFromDate:date];
            if (date) {
            [self.uniqueDate addObject:dateStr];
            }
        }
        [formater setDateFormat:@"YYYY-MM-dd"];
        if (kissDate) {
            NSString *dateStr = [person.events objectForKey:@"KISS"];
            NSDate *date = [formater dateFromString:dateStr];
            [formater setDateFormat:@"YYYY-MMMM"];
            dateStr = [formater stringFromDate:date];
            if (date) {
            [self.uniqueDate addObject:dateStr];
            }
        }
        [formater setDateFormat:@"YYYY-MM-dd"];
        if (dateDate) {
            NSString *dateStr = [person.events objectForKey:@"DATE"];
            NSDate *date = [formater dateFromString:dateStr];
            [formater setDateFormat:@"YYYY-MMMM"];
            dateStr = [formater stringFromDate:date];
            if (date) {
            [self.uniqueDate addObject:dateStr];
            }
        }
    }
}

- (Statistic *)numberOfGirlsFromDate:(NSString *)date {
    Statistic *stats = [Statistic new];
    stats.numberOfGirls = 0;
    stats.numberOfGirlsWithKissEvent = 0;
    stats.numberOfGirlsWithLoveEvent = 0;
    float rate = 0.0f;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    NSDate *dateDate;
    NSDate *kissDate;
    NSDate *loveDate;
    NSString *dateStr;
    NSString *kissStr;
    NSString *loveStr;
    for (Person *person in self.girls) {
        [formater setDateFormat:@"YYYY-MM-dd"];
        dateDate = [formater dateFromString:[person.events objectForKey:@"DATE"]];
        kissDate = [formater dateFromString:[person.events objectForKey:@"KISS"]];
        loveDate = [formater dateFromString:[person.events objectForKey:@"LOVE"]];
        [formater setDateFormat:@"YYYY-MMMM"];
        dateStr = [formater stringFromDate:dateDate];
        kissStr = [formater stringFromDate:kissDate];
        loveStr = [formater stringFromDate:loveDate];
        if ([dateStr isEqualToString:date] || [kissStr isEqualToString:date] || [loveStr isEqualToString:date]) {
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

- (void)calculateStatisticForDates {
    self.statistics = [NSMutableDictionary new];
    for (NSString *date in self.uniqueDate) {
        [self.statistics setObject:[self numberOfGirlsFromDate:date] forKey:date];
    }
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
