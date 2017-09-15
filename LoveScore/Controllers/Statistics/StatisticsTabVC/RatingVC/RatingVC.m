//
//  RatingVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "RatingVC.h"
#import "RatingCell.h"
#import "UINavigationItem+CustomBackButton.h"
#import "Person.h"
#import "PersonEntity.h"
#import "CoreDataManager.h"
#import "Statistic.h"
#import "MyGirlsVC.h"

@interface RatingVC ()

@property (nonatomic, strong)NSArray *girls;
@property (nonatomic, strong)NSArray *ratingsTitels;
@property (nonatomic, strong)NSMutableDictionary *statistics;
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;

@end

@implementation RatingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    self.ratingsTitels = [NSArray arrayWithObjects:@"9+", @"8+", @"7+", @"6+", @"5+", nil];
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
    return self.ratingsTitels.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RatingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RatingCell class])];
    [cell setCellColor:indexPath.row % 2];
    [cell setRate:[self.ratingsTitels objectAtIndex:indexPath.row]];
    Statistic *statistic = [self.statistics objectForKey:[self.ratingsTitels objectAtIndex:indexPath.row]];
    [cell setNumberOfGirls:statistic.numberOfGirls];
    [cell setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithLoveEvent] kissEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithKissEvent] averageRating:[NSNumber numberWithFloat:statistic.averageRating]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"RatingVC@MyGirlsVC" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RatingVC@MyGirlsVC"]) {
        MyGirlsVC *viewController = [segue destinationViewController];
        viewController.girls = [self getGirlsWithAgeRange:self.selectedIndexPath.row];
        viewController.titleString = [self.ratingsTitels objectAtIndex:self.selectedIndexPath.row];
        viewController.isFiltered = YES;
    }
}

#pragma mark - Private methods

- (NSArray *)getGirlsWithAgeRange:(RatingRanges)rateRange {
    NSMutableArray *girls = [NSMutableArray new];
    NSInteger minRate = 0;
    NSInteger maxRate = 0;
    switch (rateRange) {
        case moreThan9:{
            minRate = 9;
            maxRate = 11;
        }
            break;
        case between9And8:{
            minRate = 8;
            maxRate = 9;
        }
            break;
        case between8And7:{
            minRate = 7;
            maxRate = 8;
        }
            break;
        case between7And6:{
            minRate = 6;
            maxRate = 7;
        }
            break;
        case between6And5:{
            minRate = 5;
            maxRate = 6;
        }
            break;
    }
    id kissDate;
    id loveDate;
    
    for (Person *person in self.girls) {
        if ([person.rating integerValue] >= minRate && [person.rating integerValue] < maxRate ) {
            kissDate = [person.events objectForKey:@"KISS"];
            loveDate = [person.events objectForKey:@"LOVE"];
            
            if (kissDate || loveDate) {
                [girls addObject:person];
            }
        }
    }
    
    return girls;
}


- (void)setupTableView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RatingCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RatingCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}

- (Statistic *)numberOfGirlsWithRatingBetween:(NSInteger)minRating and:(NSInteger)maxRating {
    Statistic *stats = [Statistic new];
    float rate = 0.0f;
    id loveDate;
    id kissDate;
    for (Person *person in self.girls) {
        
        if ([person.rating integerValue] >= minRating && [person.rating integerValue] < maxRating) {
            
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

- (void)calculateStatistic {
    self.statistics = [NSMutableDictionary new];
    [self.statistics setObject:[self numberOfGirlsWithRatingBetween:5 and:6] forKey:@"5+"];
    [self.statistics setObject:[self numberOfGirlsWithRatingBetween:6 and:7] forKey:@"6+"];
    [self.statistics setObject:[self numberOfGirlsWithRatingBetween:7 and:8] forKey:@"7+"];
    [self.statistics setObject:[self numberOfGirlsWithRatingBetween:8 and:9] forKey:@"8+"];
    [self.statistics setObject:[self numberOfGirlsWithRatingBetween:9 and:11] forKey:@"9+"];
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
