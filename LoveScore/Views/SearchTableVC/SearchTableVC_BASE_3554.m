//
//  SearchTableVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/23/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SearchTableVC.h"
#import "UINavigationItem+CustomBackButton.h"

@interface SearchTableVC ()

@property (strong, nonatomic)NSArray *allKeys;
@property (strong, nonatomic)NSMutableArray *searchKeys;
@property (strong, nonatomic)NSArray *arrayForDict;
@property (strong, nonatomic)NSArray *searchResult;
@property (strong, nonatomic)UISearchController *searchController;

@end

@implementation SearchTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.allKeys = [self.searchDictionary keysSortedByValueUsingSelector:@selector(compare:)];
    self.searchKeys = [NSMutableArray arrayWithArray:self.allKeys];
    self.arrayForDict = [NSArray arrayWithArray:[self.searchDictionary allValues]];
    self.searchResult = [NSMutableArray new];
    [self configureSearchController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.isActive) {
        return self.searchResult.count;
    } else {
    return self.searchDictionary.count;
    }
    
}

#pragma mark - UITableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    if (self.searchController.isActive) {
        cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
    } else {
    cell.textLabel.text = [self.searchDictionary objectForKey:[self.searchKeys objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(stringWasSelected:)]) {
        [self.delegate stringWasSelected:[self.searchKeys objectAtIndex:indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - navigation bar button

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private methods

- (void)configureSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = _searchController.searchBar;
}

#pragma mark - Search bar controller

- (void)filterContentForTerm:(NSString*)searchText {
    
   // [self.searchResult removeAllObjects];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd]%@",searchText];
    
    self.searchResult = [NSArray arrayWithArray:[self.arrayForDict filteredArrayUsingPredicate:searchPredicate]];
    
    [self.tableView reloadData];

    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForTerm:searchController.searchBar.text];
}

@end
