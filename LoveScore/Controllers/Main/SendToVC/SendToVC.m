//
//  SendToVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SendToVC.h"
#import "SendToCell.h"
#import "TTTAttributedLabel + ColorText.h"
#import "Global.h"
#import "UINavigationItem+CustomBackButton.h"
#import "InboxCardVC.h"
#import "FriendsServices.h"
#import "SharingServices.h"
#import "InboxTeaserCardVC.h"
#import "CoreDataManager.h"
#import "Friend.h"
#import "ShareCard.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "SearchFriendsVC.h"


@interface SendToVC () <UITableViewDataSource, UITableViewDelegate, SendToCellDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sortedSectionTitles;
@property (nonatomic, strong) NSArray *contactsArray;
@property (nonatomic, strong) NSMutableDictionary *sections;
@property (nonatomic, strong) NSMutableArray *selectedUsers;
@property (nonatomic, strong) UIView *shareView;

@property (nonatomic, strong) FriendsServices *friendsServices;
@property (nonatomic ,strong) NSMutableArray *friendsArray;

@property (nonatomic, strong) SharingServices *sharingSerices;

@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation SendToVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsServices = [[FriendsServices alloc] init];
    self.friendsArray = [NSMutableArray new];
    [self getFriendsRequest];
    
    self.sharingSerices = [SharingServices new];
    
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    // add button to add friends
    UIImage* image3 = [UIImage imageNamed:@"friends-icon-add"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(addFriendsAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *addFriendsButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem = addFriendsButton;
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"SEND TO..." withRedWord:@"TO..."];
    self.selectedUsers = [NSMutableArray array];
    [self setupShareView];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    //    self.friendsServices = [[FriendsServicesImpl alloc] init];
    //    self.friendsArray = [NSMutableArray new];
    //    [self getFriendsRequest];
    
    [self configureSearchController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addFriendsAction:(id)sender {
    
    SearchFriendsVC *viewController = (SearchFriendsVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Friends", @"SearchFriendsId");
    
    viewController.currentFriendsArray = self.friendsArray;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedSectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSMutableArray *)[self.sections objectForKey:self.sortedSectionTitles[section]]).count;
}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *symbolsArray = [NSMutableArray new];
    
    [symbolsArray addObject:[NSString stringWithFormat:@"%@", @"♥︎"]];
    [symbolsArray addObject:[NSString stringWithFormat:@"%c", (char)35]];
    
    for (NSUInteger i = 65; i < 91; i++) {
        [symbolsArray addObject:[NSString stringWithFormat:@"%c", (char)i]];
    }
    
    return symbolsArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SendToCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendToCell class])];
    
    for(UIView *view in [tableView subviews]) {
        if([[[view class] description] isEqualToString:@"UITableViewIndex"]) {
            [view setTintColor:[UIColor colorWithRed:116.f / 255.f green:116.f / 255.f blue:116.f / 255.f alpha:1.f]];
            //            [view setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.usernameLbl setText:[((NSMutableArray *)[self.sections objectForKey:self.sortedSectionTitles[indexPath.section]]) objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

#pragma mark - Private methods

#pragma mark - Private methods

- (void)configureSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = _searchController.searchBar;
}

- (void)getFriendsRequest {
    @weakify(self);
    
    [[self.friendsServices getFriendsWithLimit:@"50" andWithPage:@"0"] subscribeNext:^(id responseObject) {
        
        @strongify(self);
        
        [self.friendsArray removeAllObjects];
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

                [self setupSectionsDictionary];
                self.tableView.delegate = self;
                self.tableView.dataSource = self;
                
            } else {
                
            }
            [self setupTableView];
            [self setupContainers];
            [self setupSectionsDictionary];
            [self.tableView reloadData];
            
        });
    }];
}

- (void)setupContainers {
    
    self.contactsArray = self.friendsArray;
    self.sections = [[NSMutableDictionary alloc] init];
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
        
        NSMutableArray *mutableArray= [self.sections objectForKey:key];
        [mutableArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    self.sortedSectionTitles =  [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SendToCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SendToCell class])];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
}


- (void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupShareView {
    CGFloat height = 40.0f;
    CGFloat width = self.view.frame.size.width;
    CGFloat y = self.view.frame.size.height;
    CGFloat x = 0;
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.view addSubview:self.shareView];
    CGFloat shareBtnHeight = self.shareView.frame.size.height;
    CGFloat shareBtnWidth = self.shareView.frame.size.width / 2;
    CGFloat shareBtnX = self.shareView.frame.size.width - shareBtnWidth;
    CGFloat shareBtnY = 0;
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(shareBtnX, shareBtnY, shareBtnWidth, shareBtnHeight)];
    [shareButton setBackgroundColor:RED_COLOR];
    [shareButton setTitle:@"SHARE NOW" forState:UIControlStateNormal];
    [shareButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share-button-icon"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareTapped:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [self.shareView addSubview:shareButton];
    
    CGFloat previewBtnHeight = self.shareView.frame.size.height;
    CGFloat previewBtnWidth = self.shareView.frame.size.width / 2;
    CGFloat previewBtnX = 0;
    CGFloat previewBtnY = 0;
    
    UIButton *previewButton = [[UIButton alloc] initWithFrame:CGRectMake(previewBtnX, previewBtnY, previewBtnWidth, previewBtnHeight)];
    
    [previewButton setBackgroundColor:[UIColor colorWithRed:237.0/255.0f green:237.0/255.0f blue:237.0/255.0f alpha:1]];
    [previewButton setTitleColor:[UIColor colorWithRed:46.0/255.0f green:46.0/255.0f blue:46.0/255.0f alpha:1] forState:UIControlStateNormal];
    [previewButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Light" size:15]];
    [previewButton setTitle:@"PREVIEW" forState:UIControlStateNormal];
    [previewButton addTarget:self action:@selector(previewTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shareView addSubview:previewButton];
    
}

- (void)showShareView {
    [UIView animateWithDuration:0.4f animations:^{
        [self.shareView setFrame:CGRectMake(self.shareView.frame.origin.x, self.view.frame.size.height - self.shareView.frame.size.height ,self.shareView.frame.size.width, self.shareView.frame.size.height)];
    }];
}

- (void)hideShareView {
    [UIView animateWithDuration:0.4f animations:^{
        [self.shareView setFrame:CGRectMake(self.shareView.frame.origin.x, self.view.frame.size.height,self.shareView.frame.size.width, self.shareView.frame.size.height)];
    }];
}

- (IBAction)shareTapped:(id)sender {
    ShareCard *shareCard = [ShareCard new];
    shareCard.uuid = self.person.uuid;
    if (self.isFullCard) {
        shareCard.cardType = @"FUL";
    } else {
        shareCard.cardType = @"TSR";
    }
    
    shareCard.recipients = self.selectedUsers;
    
    [[self.sharingSerices shareCardWithModel:shareCard] subscribeCompleted:^(void) {
        [self.selectedUsers removeAllObjects];
        [self hideShareView];
        
        //        (..)
        //        \||/
        //         /\
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            UIViewController *viewController = VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"InboxVC");
            
            [self.navigationController pushViewController:viewController animated:YES];
        });
    }];
    
}

- (IBAction)previewTapped:(id)sender {
    if (self.isTeaserCard) {
        InboxTeaserCardVC *viewController;
        viewController = (InboxTeaserCardVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"InboxTeaserCardVC");
        viewController.person = self.person;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (self.isFullCard) {
        InboxCardVC *viewController;
        viewController = (InboxCardVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"FullCheckInId");
        viewController.person = self.person;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - SendToCellDelegate methods

- (void)selectUsername:(NSString *)username {
    [self.selectedUsers addObject:username];;
    [self showShareView];
}

- (void)deselectUsername:(NSString *)username {
    [self.selectedUsers removeObject:username];
    if (self.selectedUsers.count == 0) {
        [self hideShareView];
    }
}

#pragma mark - Search bar controller

- (void)filterContentForTerm:(NSString*)searchText {
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd]%@",searchText];
    
    self.contactsArray = [NSArray arrayWithArray:[self.contactsArray filteredArrayUsingPredicate:searchPredicate]];
    [self.tableView reloadData];
    
    //    if (searchText.length >= 3) {
    //
    //        [[self.friendsServices searchUsers:searchText] subscribeNext:^(id x) {
    //
    //            NSArray *array = x;
    //
    //            for (int i = 0; i < array.count; i++) {
    //                Friend *friend = [Friend new];
    //                friend.username = ([(NSDictionary *)array[i] objectForKey:@"username"]);
    //
    //                if (([(NSDictionary *)array[i] objectForKey:@"display_name"]) != nil) {
    //                    friend.displayName = ([(NSDictionary *)array[i] objectForKey:@"display_name"]);
    //                }
    
    //                BOOL wasFound = NO;
    //                for (int i = 0; i < self.potentialFriendsArray.count; i++) {
    //                    if ([((Friend *)self.potentialFriendsArray[i]).username isEqualToString:friend.username]) {
    //                        wasFound = YES;
    //                        break;
    //                    }
    //                }
    //
    //                for (int i = 0; i < self.currentFriendsArray.count; i++) {
    //                    if ([((Friend *)self.currentFriendsArray[i]).username isEqualToString:friend.username]) {
    //                        wasFound = YES;
    //                        break;
    //                    }
    //                }
    //
    //                if (!wasFound) {
    //                    friend.friendState = FriendStatePotential;
    //                    [self.potentialFriendsArray addObject:friend];
    //                }
    //            }
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [self.tableView reloadData];
    //            });
    
    //        }];
    //    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForTerm:searchController.searchBar.text];
}


@end
