//
//  LuckyListVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "LuckyListVC.h"
#import "SideMenuModel.h"
#import "UIView+ViewCreator.h"
#import "LuckyListCell.h"
#import "NavigationTitle.h"
#import "TTTAttributedLabel + ColorText.h"
#import "SortButton.h"
#import "ActionSheetStringPicker.h"
#import "CoreDataManager.h"
#import "Person.h"
#import "FullCardVC.h"
#import "Global.h"

static NSString * const ageSortTitle = @"Age";
static NSString * const ratinSortTitle = @"Rating";
static NSString * const nameSortTitle = @"Name";
static NSString * const countrySortTitle = @"Nationality";

@interface LuckyListVC () <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *_tableView;
}
@property (weak, nonatomic) IBOutlet SortButton *sortBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGirlsLable;

- (IBAction)sortTapped:(SortButton *)sender;
@property (strong, nonatomic)NSArray *girls;
@property (strong, nonatomic)NSMutableArray *girlsWithLoveEvent;
@property (strong, nonatomic)NSIndexPath *currentIndexPath;
@property (nonatomic)NSInteger sortIndex;
@property (strong, nonatomic)NSDictionary *countriesDictionary;
@property (strong, nonatomic)AppDelegate *appDelegate;

@end

@implementation LuckyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"LUCKY LIST" withRedWord:@"LIST"];
    [[SideMenuModel sharedInstance] addEdgeSwipeOnView:self.view];
    self.girls = [[CoreDataManager instance] getGirlsFromDataBase];
    self.countriesDictionary = [[CoreDataManager instance] getCountriesDictionaryFromDataBase];
    self.sortIndex = 1;
    [self filterGirlsWithLoveEvent];
    self.girlsWithLoveEvent = (NSMutableArray *)[self girlsSortedByKey:@"firstName" ascending:YES];
    self.appDelegate = APP_DELEGATE;
    
    
    if (self.girlsWithLoveEvent.count == 1) {
        self.numberOfGirlsLable.text = [NSString stringWithFormat:@"%lu girl",(unsigned long)self.girlsWithLoveEvent.count];
    } else {
        self.numberOfGirlsLable.text = [NSString stringWithFormat:@"%lu girls",(unsigned long)self.girlsWithLoveEvent.count];
    }
    
    [self.sortBtn setTitle:@"Name" forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.appDelegate.luckyListSortType && ![self.appDelegate.luckyListSortType isEqualToString:@""]) {
        [self sortGirls:self.appDelegate.luckyListSortType];
        [self.sortBtn setTitle:self.appDelegate.luckyListSortType forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)callSideMenu:(UIBarButtonItem *)sender {
    [[SideMenuModel sharedInstance] anchorRight];
}


#pragma mark - Table view delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.girlsWithLoveEvent.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LuckyListCell *cell = (LuckyListCell *)[tableView dequeueReusableCellWithIdentifier:LuckyListCellId];
    
    if (cell == nil) {
        cell = [LuckyListCell createView];
    }
    
    [cell setPerson:[self.girlsWithLoveEvent objectAtIndex:indexPath.row] cellNumber:indexPath.row + 1 countriesDictionary:self.countriesDictionary rating:nil];
    [cell setLuckyListCellColor:indexPath.row % 2];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    [self performSegueWithIdentifier:@"LuckyList@FullCheckInSegue" sender:self];
    
}

- (void)sortGirls:(NSString *)selectedValue {
    if ([selectedValue isEqualToString:ratinSortTitle]) {
        self.girlsWithLoveEvent = (NSMutableArray *)[self girlsSortedByKey:@"rating" ascending:NO];
    }
    if ([selectedValue isEqualToString:ageSortTitle]) {
        self.girlsWithLoveEvent = (NSMutableArray *)[self girlsSortedByKey:@"age" ascending:YES];
    }
    if ([selectedValue isEqualToString:nameSortTitle]) {
        self.girlsWithLoveEvent = (NSMutableArray *)[self girlsSortedByKey:@"firstName" ascending:YES];
    }
    if ([selectedValue isEqualToString:countrySortTitle]) {
        self.girlsWithLoveEvent = (NSMutableArray *)[self girlsSortedByKey:@"nationality" ascending:YES];
    }
    
}

#pragma mark - Sorting methods

- (NSArray *)girlsSortedByKey:(NSString *)key ascending:(BOOL)ascending {
    NSArray *girls = [NSArray new];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    girls = [self.girlsWithLoveEvent sortedArrayUsingDescriptors:sortDescriptors];
    return girls;
}

- (IBAction)sortTapped:(SortButton *)sender {
    
    [ActionSheetStringPicker showPickerWithTitle:@"Sort" rows:[NSArray arrayWithObjects:ageSortTitle,nameSortTitle, countrySortTitle,  nil] initialSelection:self.sortIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.sortIndex = selectedIndex;
        [self sortGirls:selectedValue];
        self.appDelegate.luckyListSortType = selectedValue;
        [_tableView reloadData];
        [sender setTitle:selectedValue forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}


- (void)filterGirlsWithLoveEvent {
    self.girlsWithLoveEvent = [NSMutableArray new];
    id loveDate;
    for (Person *person in self.girls) {
        if (person.events.count > 0) {
            loveDate = [person.events objectForKey:@"LOVE"];
        }
        if (loveDate) {
            [self.girlsWithLoveEvent addObject:person];
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LuckyList@FullCheckInSegue"]) {
        FullCardVC *vc = [segue destinationViewController];
        vc.person = [self.girlsWithLoveEvent objectAtIndex:_currentIndexPath.row];
    }
}

@end
