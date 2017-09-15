//
//  FriendsVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/12/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FriendsVC.h"
#import "SideMenuModel.h"
#import "TTTAttributedLabel.h"
#import "UIView+ViewCreator.h"
#import "FriendsCell.h"
#import "Global.h"
#import "SearchFriendsVC.h"
#import "FriendsServices.h"
#import "CoreDataManager.h"
#import "FriendsEntity.h"
#import "Friend.h"
#import "CustomBarButtonView.h"
#import "UIView+ViewCreator.h"

#define LIMIT @"25"

@interface FriendsVC () <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *notEmptyFriendsView;

@property (strong, nonatomic) IBOutlet UIView *emptyFriendsView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItem;
@property (nonatomic, strong) NSMutableArray *searchResult;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSIndexPath* swipedCellIndexPath;

@property (nonatomic, strong) NSMutableDictionary *sections;
@property (nonatomic, strong) NSArray *sortedSectionTitles;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) TTTAttributedLabel *attributedLabel;
@property (nonatomic, strong) UIImageView *balloonImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger totalPages;
@property (nonatomic) BOOL refresh;
@property (nonatomic, strong) FriendsServices *friendsServices;
@property (nonatomic ,strong) NSMutableArray *friendsArray;
@property (nonatomic, strong) CustomBarButtonView *buttonView;
@property (nonatomic, assign) NSInteger countOfIncoming;
@property (nonatomic, assign) NSUInteger count;
@end

@implementation FriendsVC

#pragma mark - constants

#pragma mark - Init and systems methods


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsServices = [[FriendsServices alloc] init];
    
    self.friendsArray = [NSMutableArray new];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self setupRefreshControl];
    [[SideMenuModel sharedInstance] addEdgeSwipeOnView:self.view];
    self.refresh = YES;
    self.buttonView = [CustomBarButtonView createView];
    [self setupBarButtonView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.friendsArray removeAllObjects];
    self.currentPage = 0;
    self.count = 0;
    if ([[SyncManager sharedInstance] connected]) {
        [self getFriendsRequestWithPage:self.currentPage withCompletion:nil];
        
        [[self.friendsServices getIncomingFriendsWithLimit:@"25" andWithPage:@"1" savingToDatabase:NO] subscribeNext:^(id x) {
            NSArray *friendRequests = [x objectForKey:@"data"];
            if (friendRequests && friendRequests.count == 0) {
                self.barButtonItem.customView = nil;
            } else {
                [self.buttonView setRequestsCount:friendRequests.count];
            }
        }];
        [self.tableView reloadData];
    } else {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning!"
                                              message:@"Check your internet connection."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *showWarningAction = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action)
                                            {
                                                
                                            }];
        
        [alertController addAction:showWarningAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        alertController.view.tintColor = RED_COLOR;
        self.barButtonItem.customView = nil;
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y <= -72) {
        if (self.refresh) {
            self.refresh = NO;
        [self.refreshControl beginRefreshing];
        [self refreshView:self.refreshControl];
        }
    }
}

#pragma mark - Private methods

- (void)setupBarButtonView {
    self.barButtonItem.customView = self.buttonView;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchFriendsTapped:)];
    [self.buttonView addGestureRecognizer:recognizer];
}

- (IBAction)searchFriendsTapped:(id)sender {
    [self performSegueWithIdentifier:@"Friends@SearchFriends" sender:self];
}

- (void)getFriendsRequestWithPage:(NSInteger)page withCompletion:(nullable void(^)())completion {
    
    @weakify(self);
    
    [[self.friendsServices getFriendsWithLimit:LIMIT andWithPage:[NSString stringWithFormat:@"%zd",page+1]] subscribeNext:^(id responseObject) {
        self.currentPage = [[[responseObject objectForKey:@"pagination"] objectForKey:@"current_page"] integerValue];
        self.totalPages = [[[responseObject objectForKey:@"pagination"] objectForKey:@"total_pages"] integerValue];
        @strongify(self);
        
        NSDictionary *dictionaryResponseObject = responseObject;
        
        if (responseObject && dictionaryResponseObject.count > 0) {
            
            NSArray *friendsArray = [responseObject objectForKey:@"data"];
            
            for (int i = 0; i < friendsArray.count; i++) {
                
                Friend *friend = [Friend new];
                friend.username = ([(NSDictionary *)friendsArray[i] objectForKey:@"username"]);
                
                if (([(NSDictionary *)friendsArray[i] objectForKey:@"display_name"]) != nil) {
                    friend.displayName = ([(NSDictionary *)friendsArray[i] objectForKey:@"display_name"]);
                }
                
                friend.friendState = FriendStateCurrentFriend;
                [self.friendsArray addObject:friend];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.friendsArray && self.friendsArray.count > 0) {
                self.sections = [[NSMutableDictionary alloc] init];
                
                [_notEmptyFriendsView setHidden:NO];
                [_emptyFriendsView setHidden:YES];
                [self setupSectionsDictionary];
                self.tableView.delegate = self;
                self.tableView.dataSource = self;
            } else {
                [_notEmptyFriendsView setHidden:YES];
                [_emptyFriendsView setHidden:NO];
            }
            
            if (self.refreshControl && self.refreshControl.isRefreshing) {
                [self.refreshControl endRefreshing];
                
                self.tableView.scrollEnabled = YES;
                self.tableView.allowsSelection = YES;
                
                [self.arrowImageView.layer removeAnimationForKey:@"rotationAnimation"];
                [self.attributedLabel setText:@"Pull down to update"];
                [self.arrowImageView setImage:[UIImage imageNamed:@"lovebox-icon-arrowdown"]];
            }
            [self.tableView reloadData];
            if (completion) {
            completion();
            }
        });
        
        if (self.currentPage < self.totalPages) {
            [self getFriendsRequestWithPage:self.currentPage withCompletion:nil];
        }
    } completed:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (NSArray *)rightButton {
    NSMutableArray *rightUtilityButton = [NSMutableArray new];
    
    [rightUtilityButton sw_addUtilityButtonWithColor:RED_COLOR icon:[UIImage imageNamed:@"delete"]];
    
    return rightUtilityButton;
}

- (void)hideAllUtilityButtons {
    
    FriendsCell *friendCell = [self.tableView cellForRowAtIndexPath:self.swipedCellIndexPath];
    [friendCell hideUtilityButtonsAnimated:YES];
}

- (void)setupSectionsDictionary {
    for (Friend *friend in self.friendsArray) {
        
        if (![[self.sections allKeys] containsObject:[[friend.username substringToIndex:1] uppercaseString]]) {
            [self.sections setObject:[NSMutableArray new] forKey:[[friend.username substringToIndex:1] uppercaseString]];
        }
    }
    
    for (Friend *friend in self.friendsArray) {
        
        [((NSMutableArray *)[self.sections objectForKey:[[friend.username substringToIndex:1] uppercaseString]]) addObject:friend.username];
    }
    
    for(NSString *key in self.sections) {
        [[self.sections objectForKey:key] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    self.sortedSectionTitles =  [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setBackgroundColor:[UIColor colorWithRed:247.f / 255.f green:247.f / 255.f blue:247.f / 255.f alpha:1.f]];
    
    [self.refreshControl setClipsToBounds:YES];
    [self.refreshControl setTintColor:[UIColor clearColor]];
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    
    //set image view with baloon on left corener
    self.balloonImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pull_refresh_balloon"]];
    [self.balloonImageView setFrame:CGRectMake(20, 10, self.refreshControl.bounds.size.height, self.refreshControl.bounds.size.height)];
    [self.refreshControl addSubview:self.balloonImageView];
    
    //set label in the middle of screen
    self.attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    self.attributedLabel.numberOfLines = 0;
    self.attributedLabel.textAlignment = NSTextAlignmentCenter;
    self.attributedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.attributedLabel.tintColor = [UIColor whiteColor];
    [self.attributedLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14.f]];
    [self.attributedLabel setText:@"Pull down to update"];
    //    [attributedLabel sizeToFit];
    [self.refreshControl addSubview:self.attributedLabel];
    
    //add image view in right corner
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 13, 33, 33)];
    [self.arrowImageView setImage:[UIImage imageNamed:@"lovebox-icon-arrowdown"]];
    [self.arrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.refreshControl addSubview:self.arrowImageView];
    
    [self.tableView addSubview:self.refreshControl];
}

-(void)refreshView:(UIRefreshControl *)refresh {
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
    
    NSString *textForLabel = @"Updating your LoveBox…";
    
    [self.attributedLabel setText:textForLabel afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
        NSRange whiteRange = [textForLabel rangeOfString:@"Box"];
        
        if (whiteRange.location != NSNotFound) {
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:whiteRange];
        }
        
        return mutableAttributedString;
    }];
    
    [self.arrowImageView setImage:[UIImage imageNamed:@"lovebox-icon-refresh"]];
    
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotate.duration = 0.5;
    rotate.repeatCount = 100;
    
    [self.arrowImageView.layer addAnimation:rotate forKey:@"rotationAnimation"];
    self.currentPage = 0;
    if ([[SyncManager sharedInstance] connected]) {
        [self.friendsArray removeAllObjects];
        [self getFriendsRequestWithPage:self.currentPage withCompletion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning!"
                                              message:@"Check your internet connection."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *showWarningAction = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action)
                                            {
                                                
                                            }];
        
        [alertController addAction:showWarningAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        alertController.view.tintColor = RED_COLOR;
    }
}

#pragma mark - Actions

- (IBAction)callSideMenu:(UIBarButtonItem *)sender {
    
    [self hideAllUtilityButtons];
    
    [[SideMenuModel sharedInstance] anchorRight];
}

- (IBAction)searchButtonAction:(id)sender {
    
    if ([[SyncManager sharedInstance] connected]) {
        [self performSegueWithIdentifier:@"Friends@SearchFriends" sender:self];
    } else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning!"
                                              message:@"Check your internet connection."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *showWarningAction = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action)
                                            {
                                                
                                            }];
        
        [alertController addAction:showWarningAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        alertController.view.tintColor = RED_COLOR;
    }
}

#pragma mark - UITableView delegate and datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.friendsArray && self.friendsArray.count > 0) {
        return self.sortedSectionTitles.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.friendsArray && self.friendsArray.count > 0) {
        return ((NSMutableArray *)[self.sections objectForKey:self.sortedSectionTitles[section]]).count;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 53.f)];
    
    [view setBackgroundColor:[UIColor colorWithRed:247.f / 255.f green:247.f / 255.f blue:247.f / 255.f alpha:1]];
    
    UILabel *letterLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, view.frame.size.width, view.frame.size.height)];
    [letterLabel setNumberOfLines:0];
    [letterLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16.f]];
    [letterLabel setTextColor:RED_COLOR];
    
    [letterLabel setText:self.sortedSectionTitles[section]];
    [view addSubview:letterLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 53.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 51.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCellId"];
    
    if (!cell) {
        cell = [FriendsCell createView];
    }
    cell.tag = self.count;
    self.count++;
//    Friend *friend = ((Friend *)self.friendsArray[indexPath.row]);
    
    NSString *key = [self.sortedSectionTitles objectAtIndex:indexPath.section];
    NSString *name = [[self.sections objectForKey:key] objectAtIndex:indexPath.row];

    [cell setNameString:name];
    
    [cell setRightUtilityButtons:[self rightButton] WithButtonWidth:cell.frame.size.height + 10];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    
    if (self.swipedCellIndexPath != nil){
        FriendsCell *friendCell = [self.tableView cellForRowAtIndexPath:self.swipedCellIndexPath];
        [self swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:friendCell];
    }
    FriendsCell *friendCell = (FriendsCell *)cell;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.swipedCellIndexPath = indexPath;
    
    if(state ==kCellStateLeft){
        friendCell.swipeCellView.alpha = 0.2f;
    }
    else if (state ==kCellStateRight){
        friendCell.swipeCellView.alpha = 0.2f;
    }
    else {
        friendCell.swipeCellView.alpha = 0.0f;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *key = [self.sortedSectionTitles objectAtIndex:indexPath.section];
    NSString *name = [[self.sections objectForKey:key] objectAtIndex:indexPath.row];

    @weakify(self);
    [[self.friendsServices deleteFriendsRequest:name] subscribeCompleted:^() {
        @strongify(self);
        self.currentPage = 0;
        [self.friendsArray removeAllObjects];
        [self getFriendsRequestWithPage:self.currentPage withCompletion:nil];
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Friends@SearchFriends"]) {
        SearchFriendsVC *vc = [segue destinationViewController];
        
        vc.currentFriendsArray = self.friendsArray;
    }
}

@end
