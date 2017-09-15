//
//  DateHistoryVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "DateHistoryVC.h"
#import "DateHistoryCell.h"
#import "UINavigationItem+CustomBackButton.h"
#import "Person.h"
#import "PersonEntity.h"
#import "CoreDataManager.h"
#import "MyGirlsVC.h"

@interface DateHistoryVC ()

@property (nonatomic, strong)NSArray *girls;
@property (nonatomic, strong)NSArray *titles;
@property (nonatomic, strong)NSArray *namesForImages;
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;

@end

@implementation DateHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    self.titles = [NSArray arrayWithObjects:@"Date", @"Kiss", @"Love", nil];
    self.namesForImages = [NSArray arrayWithObjects:@"bubble_in_oval", @"lips_in_oval", @"heart_in_oval", nil];
    
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
    return 3;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DateHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DateHistoryCell class])];
    [cell setCellColor:indexPath.row % 2];
    [cell setEventImageWithName:[self.namesForImages objectAtIndex:indexPath.row]];
    [cell setEventTitle:[self.titles objectAtIndex:indexPath.row]];
    [cell setNumberOfGirls:[NSNumber numberWithInteger:[self numberOfGirlsForEvent:[[self.titles objectAtIndex:indexPath.row] uppercaseString]]]];
    [cell setAverageRating:[NSNumber numberWithFloat:[self averageRatingForEvent:[[self.titles objectAtIndex:indexPath.row] uppercaseString]]]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"DateHistoryVC@MyGirlsVC" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DateHistoryVC@MyGirlsVC"]) {
        MyGirlsVC *viewController = [segue destinationViewController];
        viewController.girls = [self getGirlsForEvent:[self.titles[self.selectedIndexPath.row] uppercaseString]];
        viewController.titleString = [self.titles objectAtIndex:self.selectedIndexPath.row];
        viewController.isFiltered = YES;
    }
}

#pragma mark - Private methods

- (NSArray *)getGirlsForEvent:(NSString *)eventKey {
    NSMutableArray *girls = [NSMutableArray new];
    id date;
    for(Person *person in self.girls){
        id kissDate = [person.events objectForKey:@"KISS"];
        id loveDate = [person.events objectForKey:@"LOVE"];
        if (person.events.count > 0) {
            date = [person.events objectForKey:eventKey];
        }
        if (date && [eventKey isEqualToString:@"DATE"] && !kissDate && !loveDate) {
            [girls addObject:person];
        } else if (date && [eventKey isEqualToString:@"KISS"] && !loveDate){
            [girls addObject:person];
        } else if (date && [eventKey isEqualToString:@"LOVE"]) {
            [girls addObject:person];
        }

    }
    return girls;
}

- (void)setupTableView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DateHistoryCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([DateHistoryCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}


- (NSInteger)numberOfGirlsForEvent:(NSString *)eventKey {
    NSInteger numberOfGirls = 0;
    id date;
    for (Person *person in self.girls) {
        id kissDate = [person.events objectForKey:@"KISS"];
        id loveDate = [person.events objectForKey:@"LOVE"];
        if (person.events.count > 0) {
            date = [person.events objectForKey:eventKey];
        }
        if (date && [eventKey isEqualToString:@"DATE"] && !kissDate && !loveDate) {
            numberOfGirls++;
        } else if (date && [eventKey isEqualToString:@"KISS"] && !loveDate){
            numberOfGirls++;
        } else if (date && [eventKey isEqualToString:@"LOVE"]) {
            numberOfGirls++;
        }
    }
    return numberOfGirls;
}

- (float)averageRatingForEvent:(NSString *)eventKey {
    float totalRating = 0.0f;
    NSInteger numberOfGirls = 0;
    id date;
    for (Person *person in self.girls) {
        id kissDate = [person.events objectForKey:@"KISS"];
        id loveDate = [person.events objectForKey:@"LOVE"];
        if (person.events.count > 0) {
            date = [person.events objectForKey:eventKey];
        }
        if (date && [eventKey isEqualToString:@"DATE"] && !kissDate && !loveDate) {
            totalRating += [person.rating floatValue];
            numberOfGirls++;
        } else if (date && [eventKey isEqualToString:@"KISS"] && !loveDate){
            totalRating += [person.rating floatValue];
            numberOfGirls++;
        } else if (date && [eventKey isEqualToString:@"LOVE"]) {
            totalRating += [person.rating floatValue];
            numberOfGirls++;
        }
    }
    
    return totalRating / numberOfGirls;
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
