//
//  StatisticsTabVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "StatisticsTabVC.h"
#import "StatisticsTabCell.h"
#import "Global.h"
#import "TTTAttributedLabel + ColorText.h"


@interface StatisticsTabVC ()
@property(strong, nonatomic)NSArray *categoryNames;
@property(strong, nonatomic)NSArray *imageNames;
@end

@implementation StatisticsTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StatisticsTabCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([StatisticsTabCell class])];
    
    _categoryNames = [NSArray arrayWithObjects:@"Age", @"Hair Color", @"Nationality", @"Date History", @"Months", @"Years", nil];
    
    //  Omitted by Dany Iliev, 08.22.2017 17:11:18 PM
    //    @"Potential",
    
    _imageNames = [NSArray arrayWithObjects:@"age", @"hair_color", @"nationality", @"date_history", @"calendar", @"calendar", nil];
    
    //  Omitted by Dany Iliev, 08.22.2017 17:11:18 PM
    //    @"potential",

    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
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
    
    [cell setCategoryName:_categoryNames[indexPath.row]];
    [cell setImageWithImageName:_imageNames[indexPath.row]];
    [cell setCellColor:indexPath.row % 2];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController = VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Statistics", [_categoryNames objectAtIndex:indexPath.row]);
    NSString *title = [[_categoryNames objectAtIndex:indexPath.row] uppercaseString];
    NSString *redString = [self redPartOfTitle:title];
    viewController.navigationItem.titleView = [TTTAttributedLabel getString:title withRedWord:redString];

    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Private methods

- (NSString *)redPartOfTitle:(NSString *)title {
    NSMutableString *redString = [NSMutableString new];
    NSArray *strings = [title componentsSeparatedByString:@" "];
    for (int i = 1; i < strings.count; i++) {
        [redString insertString:strings[i] atIndex:i-1];
    }
    
    return redString;
}

@end
