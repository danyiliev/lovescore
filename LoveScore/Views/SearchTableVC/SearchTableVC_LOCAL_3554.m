//
//  SearchTableVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/23/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SearchTableVC.h"
#import "UINavigationItem+CustomBackButton.h"

@interface SearchTableVC () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>


@property (strong, nonatomic)NSArray *allKeys;
@property (strong, nonatomic)NSMutableArray *searchKeys;
@property (strong, nonatomic)NSArray *arrayForSearch;
@property (strong, nonatomic)NSArray *searchResult;
@property (strong, nonatomic)UISearchController *searchController;

@end

@implementation SearchTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    self.allKeys = [self.searchDictionary keysSortedByValueUsingSelector:@selector(compare:)];
    self.searchKeys = [NSMutableArray arrayWithArray:self.allKeys];
    if (self.searchDictionary) {
    self.arrayForSearch = [NSArray arrayWithArray:[self.searchDictionary allValues]];
    } else {
        self.arrayForSearch = [NSArray arrayWithArray:self.searchValuesArray];
    }
    self.searchResult = [NSMutableArray new];
    self.searchValuesArray = [self.searchValuesArray sortedArrayUsingSelector:@selector(compare:)];
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
    NSUInteger numbersOfRows = 0;
    
    if (self.searchDictionary) {
        if (self.searchController.isActive) {
            numbersOfRows = self.searchResult.count;
        } else {
            numbersOfRows = self.searchDictionary.count;
        }
    } else {
        if (self.searchController.isActive) {
            numbersOfRows =  self.searchResult.count;
        } else {
            numbersOfRows = self.searchValuesArray.count;
        }

    }
    
    return numbersOfRows;
}

#pragma mark - UITableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    if (self.searchDictionary) {
    if (self.searchController.isActive) {
        cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
    } else {
    cell.textLabel.text = [self.searchDictionary objectForKey:[self.searchKeys objectAtIndex:indexPath.row]];
    }
    
    } else {
        if (self.searchController.isActive) {
            cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
        } else {
            cell.textLabel.text = [self.searchValuesArray objectAtIndex:indexPath.row];
        }

    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(stringWasSelected:)]) {
        
        if (self.searchDictionary) {
            if (self.searchController.isActive) {
                [self.delegate stringWasSelected:[[self.searchDictionary allKeysForObject:[self.searchResult objectAtIndex:indexPath.row]] objectAtIndex:0]];
                [self.searchController setActive:NO];
            } else {
        [self.delegate stringWasSelected:[self.searchKeys objectAtIndex:indexPath.row]];
            }
        
        } else {
            
            if ([self.searchController isActive]) {
                [self.delegate stringWasSelected:[self.searchResult objectAtIndex:indexPath.row]];
                [self.searchController setActive:NO];
            } else {
            [self.delegate stringWasSelected:[self.searchValuesArray objectAtIndex:indexPath.row]];
            }
        }
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
    
    self.searchResult = [NSArray arrayWithArray:[self.arrayForSearch filteredArrayUsingPredicate:searchPredicate]];
    
    [self.tableView reloadData];

    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForTerm:searchController.searchBar.text];
}

@end
