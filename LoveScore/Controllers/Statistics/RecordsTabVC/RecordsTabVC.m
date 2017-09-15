//
//  RecordsTabVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "RecordsTabVC.h"
#import "StatisticsTabCell.h"
#import "Global.h"
#import "TTTAttributedLabel + ColorText.h"
#import "CoreDataManager.h"
#import "BestVC.h"

@interface RecordsTabVC ()

@property (strong, nonatomic)NSArray *imageNames;
@property (strong, nonatomic)NSArray *categoryNames;
@property (strong, nonatomic)NSArray *girls;
@property (strong, nonatomic)NSArray *filteredGirls;

@end

@implementation RecordsTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StatisticsTabCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([StatisticsTabCell class])];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _imageNames = [NSArray arrayWithObjects:@"best-all-time", @"best-body", @"best-face", @"best-personality", @"best-kissed", @"best-loved", nil];
    _categoryNames = [NSArray arrayWithObjects:@"Best All Time", @"Best Body", @"Best Face", @"Best Personality", @"Best Kiss", @"Best Love", nil];
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
    return _categoryNames.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StatisticsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StatisticsTabCell class])];
   
    [cell setCellColor:indexPath.row % 2];
    [cell setImageWithImageName:_imageNames[indexPath.row]];
    [cell setCategoryName:_categoryNames[indexPath.row]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BestVC *viewController = (BestVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Statistics", @"BestVC");
    viewController.recordType = [self.categoryNames objectAtIndex:indexPath.row];
    NSString *title = [(NSString *)[_categoryNames objectAtIndex:indexPath.row] uppercaseString];
    NSMutableString *redString = [self redPartOfTitle:title];
    viewController.navigationItem.titleView = [TTTAttributedLabel getString:title withRedWord:redString];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Private methods

- (NSMutableString *)redPartOfTitle:(NSString *)title {
    NSMutableString *redString = [NSMutableString new];
    NSArray *strings = [title componentsSeparatedByString:@" "];
    for (int i = 1; i < strings.count; i++) {
        [redString insertString:strings[i] atIndex:[redString length]];
        if (i < strings.count - 1) {
        [redString insertString:@" " atIndex:[redString length]];
        }
    }
    return redString;
}


@end
