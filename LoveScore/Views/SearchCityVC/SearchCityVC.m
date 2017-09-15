//
//  SearchCityVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/8/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "SearchCityVC.h"
#import "UINavigationItem+CustomBackButton.h"
#import "DataStoreServices.h"

@interface SearchCityVC ()<UITableViewDataSource,UITableViewDelegate, UISearchResultsUpdating,UISearchControllerDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) DataStoreServices *dataStoreServices;

@property (nonatomic, strong) NSArray *searchResult;

@end

@implementation SearchCityVC

#pragma mark - init

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataStoreServices = [DataStoreServices new];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    [self configureSearchController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger numbersOfRows = 0;
    
    if (self.searchResult) {
        numbersOfRows = self.searchResult.count;
    }
    
    return numbersOfRows;
}

#pragma mark - UITableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    NSString *cityName = ([(NSDictionary *)self.searchResult[indexPath.row] objectForKey:@"description"]);
    [cell.textLabel setText:cityName];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    [cell.textLabel setMinimumScaleFactor:0.5f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(cityWasSelected:)]) {
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        [dictionary setObject:[self.searchResult[indexPath.row] objectForKey:@"description"] forKey:@"name"];
        
        [dictionary setObject:[self.searchResult[indexPath.row] objectForKey:@"place_id"] forKey:@"place_id"];
        
        [self.delegate cityWasSelected:[dictionary copy]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];}

#pragma mark - Search bar controller

- (void)filterContentForTerm:(NSString*)searchText {
    if (searchText.length > 0) {
        @weakify(self);
        [[self.dataStoreServices getCitiesListWithSearchWord:searchText inCountry:self.country]
         subscribeNext:^(id responseObject) {
             @strongify(self);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.searchResult = [responseObject objectForKey:@"predictions"];
                 [self.tableView reloadData];
             });
         }
         error:^(NSError *error) {
             NSLog(@"Cities Error - %@", error);
         }];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForTerm:searchController.searchBar.text];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.searchResult = nil;
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)configureSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchController.searchBar;
    [self.searchController setActive:YES];
}

#pragma mark - Bar Buttons Actions

-(void)backBarButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    [self.searchController.searchBar becomeFirstResponder];
}

@end
