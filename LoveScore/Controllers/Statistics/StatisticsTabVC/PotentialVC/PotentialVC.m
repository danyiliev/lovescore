//
//  PotentialVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "PotentialVC.h"
#import "PotentialCell.h"
#import "UINavigationItem+CustomBackButton.h"
#import "Person.h"
#import "PersonEntity.h"
#import "CoreDataManager.h"
#import "Statistic.h"
#import "MyGirlsVC.h"

@interface PotentialVC ()

@property (strong, nonatomic)NSArray *girls;
@property (strong, nonatomic)NSArray *potentialTitles;
@property (strong, nonatomic)NSDictionary *categories;
@property (strong, nonatomic)NSMutableDictionary *statistics;
@property (strong, nonatomic)NSIndexPath *selectedIndexPath;

@end

@implementation PotentialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    self.potentialTitles = [NSArray arrayWithObjects:@"Wedding material", @"Girlfriend material", @"Friends with benefits", @"Backup girl", nil];
    self.categories = @{
                        @"wedding" : @"Wedding material",
                        @"girlfriend" : @"Girlfriend material",
                        @"friends" : @"Friends with benefits",
                        @"backup" : @"Backup girl"
                        };
    [self calculateStatisticWithPotentials];
    
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
    return self.potentialTitles.count;
}

#pragma mark Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PotentialCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PotentialCell class])];
    [cell setCellColor:indexPath.row % 2];
    [cell setPotentialText:[self.potentialTitles objectAtIndex:indexPath.row]];
    Statistic *statistic = [self.statistics objectForKey:[self.potentialTitles objectAtIndex:indexPath.row]];
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
    [self performSegueWithIdentifier:@"PotentialVC@MyGirlsVC" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PotentialVC@MyGirlsVC"]) {
        MyGirlsVC *viewController = [segue destinationViewController];
        viewController.girls = [self getGirlsWithCategory:[self.potentialTitles objectAtIndex:self.selectedIndexPath.row]];
        viewController.titleString = [self.potentialTitles objectAtIndex:self.selectedIndexPath.row];
        viewController.isFiltered = YES;
    }
}

#pragma mark - Private methods

- (NSMutableArray *)getGirlsWithCategory:(NSString *)category {
    NSMutableArray *girls = [NSMutableArray new];
    for (Person *person in self.girls) {
        
        id kissDate = [person.events objectForKey:@"KISS"];
        id loveDate = [person.events objectForKey:@"LOVE"];
        
        if ([[self.categories objectForKey:person.category] isEqualToString:category] && (kissDate || loveDate)) {
            [girls addObject:person];
        }
    }
    
    return girls;
}


- (void)setupTableView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PotentialCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([PotentialCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}

- (Statistic *)numberOfGirlsWithPotential:(NSString *)potential {
    Statistic *stats = [Statistic new];
    float rate = 0.0f;
    id loveDate;
    id kissDate;
    for (Person *person in self.girls) {
        
        
        if ([[self.categories objectForKey:person.category] isEqualToString:potential]) {
            
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

- (void)calculateStatisticWithPotentials {
    self.statistics = [NSMutableDictionary new];
    for (NSString *category in self.potentialTitles) {
        [self.statistics setObject:[self numberOfGirlsWithPotential:category] forKey:category];
    }
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
