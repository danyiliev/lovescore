//
//  HairColorVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "HairColorVC.h"
#import "HairColorCell.h"
#import "UINavigationItem+CustomBackButton.h"
#import "CoreDataManager.h"
#import "Statistic.h"
#import "Person.h"
#import "MyGirlsVC.h"

@interface HairColorVC ()

@property (strong, nonatomic)NSArray *girls;
@property (strong, nonatomic)NSDictionary *hairColorDictionary;
@property (strong, nonatomic)NSArray *hairColorTitles;
@property (strong, nonatomic)NSMutableDictionary *statistics;
@property (strong, nonatomic)NSIndexPath *selectedindexPath;


@end

@implementation HairColorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    self.hairColorDictionary = @{
                                 @"Black" : @"BLK",
                                 @"Brunette" : @"BRW",
                                 @"Blonde" : @"BLD",
                                 @"Ginger" : @"RED",
                                 @"Other" : @"OTH"
                                 };
    self.hairColorTitles = [NSArray arrayWithObjects:@"Black", @"Brunette", @"Blonde", @"Ginger",@"Other", nil];
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
    return self.hairColorTitles.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HairColorCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HairColorCell class])];
    [cell setCellColor:indexPath.row % 2];
    Statistic *statistic = [self.statistics objectForKey:[self.hairColorTitles objectAtIndex:indexPath.row]];
    [cell setHairColorText:[self.hairColorTitles objectAtIndex:indexPath.row]];
    [cell setHairColorImageWithString:[[self.hairColorTitles objectAtIndex:indexPath.row] lowercaseString]];
    [cell setNumberOfGirls:statistic.numberOfGirls];
    [cell setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithLoveEvent] kissEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithKissEvent] averageRating:[NSNumber numberWithFloat:statistic.averageRating]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedindexPath = indexPath;
    [self performSegueWithIdentifier:@"HairColorVC@MyGirlsVC" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HairColorVC@MyGirlsVC"]) {
        NSString *hairColor = [self.hairColorDictionary objectForKey:[self.hairColorTitles objectAtIndex:self.selectedindexPath.row]];
        
        MyGirlsVC *viewController = [segue destinationViewController];
        viewController.girls = [self getGirlsWithHairColor:hairColor];
        viewController.titleString = [self.hairColorTitles objectAtIndex:self.selectedindexPath.row];
        viewController.isFiltered = YES;
    }
}

#pragma mark - Private methods

- (NSArray *)getGirlsWithHairColor:(NSString *)hairColor {
    NSMutableArray *girls = [NSMutableArray new];
    
    id kissDate;
    id loveDate;
    for (Person *person in self.girls) {
        
        if ([person.hairColor isEqualToString:hairColor]) {
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
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HairColorCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HairColorCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}

- (Statistic *)numberOfGirlsWithHairColor:(NSString *)hairColor {
    Statistic *stats = [Statistic new];
    float rate = 0.0f;
    id kissDate = nil;
    id loveDate = nil;
    for (Person *person in self.girls) {
        if ([person.hairColor isEqualToString:hairColor]) {
            
            if (person.events.count > 0) {
                kissDate = [person.events objectForKey:@"KISS"];
                loveDate = [person.events objectForKey:@"LOVE"];
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
    for (NSString *hairColor in self.hairColorTitles) {
        [self.statistics setObject:[self numberOfGirlsWithHairColor:[self.hairColorDictionary objectForKey:hairColor]] forKey:hairColor];
    }
}
#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
