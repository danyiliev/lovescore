//
//  InboxVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/12/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "InboxVC.h"
#import "InboxCardVC.h"
#import "SideMenuModel.h"
#import "InboxCell.h"
#import "InboxTeaserCardVC.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "NetworkActivityIndicator.h"
#import "TTTAttributedLabel.h"
#import "TTTAttributedLabel + ColorText.h"
#import "SharingServices.h"
#import "RetrieveInboxEntity.h"
#import "RetrieveInbox.h"
#import "CoreDataManager.h"
#import "AppDelegate.h"
#import "EmptyInboxCell.h"
#import "UIViewController+AlertController.h"

@interface InboxVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) TTTAttributedLabel *attributedLabel;
@property (nonatomic, strong) UIImageView *balloonImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) NSMutableArray *inbox;
@property (weak, nonatomic) IBOutlet UIView *emptyInboxView;
@property (nonatomic, weak) AppDelegate *appDelegate;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger totalPages;

@property (nonatomic, strong) SharingServices *sharingImpl;
@end

@implementation InboxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InboxCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([InboxCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EmptyInboxCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([EmptyInboxCell class])];
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"INBOX" withRedWord:@"BOX"];
    [[SideMenuModel sharedInstance] addEdgeSwipeOnView:self.view];
    self.appDelegate = APP_DELEGATE;
    [self setupRefreshControl];
    self.inbox = [NSMutableArray new];
    self.sharingImpl = [SharingServices new];
    self.currentPage = 0;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.currentPage = 0;
    if([self checkInternet]) {
        [self updateInboxWithLimit:25 page:self.currentPage completion:^{
            
        }];
    }
}

- (IBAction)callSideMenu:(UIBarButtonItem *)sender {
    [[SideMenuModel sharedInstance] anchorRight];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.inbox.count == 0) {
        return 1;
    } else {
        return self.inbox.count;
    }
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == [tableView numberOfRowsInSection:0] - 1 && self.currentPage < self.totalPages) {
        [self updateInboxWithLimit:25 page:self.currentPage completion:^{
            
        }];
    }
    
    if (self.inbox.count == 0) {
        EmptyInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyInboxCell class])];
        return cell;
    } else {
    
    InboxCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InboxCell class])];
    [cell setRetrieveInboxModel:[self.inbox objectAtIndex:indexPath.row]];
    
    return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.inbox.count == 0) {
        return self.view.frame.size.height - 64;
    } else {
        return 70.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RetrieveInbox *inboxItem = [self.inbox objectAtIndex:indexPath.row];
    NSDate *cardDate = [self.appDelegate.timeDictionary objectForKey:inboxItem.ident];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:cardDate];
    SharingServices *sharingServ = [SharingServices new];
    
    if ([inboxItem.status isEqualToString:@"SNT"]) {
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
    }
    
    if ([inboxItem.cardType isEqualToString:@"TSR"] && [inboxItem.type isEqualToString:@"incoming"]) {
        if (timeInterval < 10 || !cardDate) {
            InboxTeaserCardVC *viewController = (InboxTeaserCardVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"InboxTeaserCardVC");
            [[sharingServ getRetrieveSingleCardWithIdent:inboxItem.ident] subscribeNext:^(id x) {
                viewController.card = (CardModel *)x;
                [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:viewController animated:YES];
                });

            }];
        }
    }
    if ([inboxItem.cardType isEqualToString:@"FUL"] && [inboxItem.type isEqualToString:@"incoming"]) {
        if (timeInterval < 3600 || !cardDate) {
            InboxCardVC *viewController = (InboxCardVC *)VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(@"Main", @"InboxCardVC");
            //viewController.ident = inboxItem.ident;
            [[sharingServ getRetrieveSingleCardWithIdent:inboxItem.ident] subscribeNext:^(id x) {
                CardModel *cardModel = (CardModel *)x;
                viewController.card = cardModel;
                [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:viewController animated:YES];
                });
            }];
        }
    }
    [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y < -125) {
        [self.refreshControl beginRefreshing];
        [self refreshView:self.refreshControl];
    }
}




#pragma mark - Private methods

- (void)updateInboxWithLimit:(NSInteger)limit page:(NSInteger)page completion:(void(^)()) completion {
    @weakify(self);
    [[self.sharingImpl getRetrieveInboxWithLimit:limit andWithPage:page + 1 savingToDatabase:YES] subscribeNext:^(id x) {
        self.currentPage = [[[x objectForKey:@"pagination"] objectForKey:@"current_page"] integerValue];
        self.totalPages = [[[x objectForKey:@"pagination"] objectForKey:@"total_pages"] integerValue];
    } completed:^(void) {
        @strongify(self);
        [self.inbox removeAllObjects];
        NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RetrieveInbox"];
        [lFetchRequest setReturnsObjectsAsFaults:NO];
        
        NSError *lError = nil;
        NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
        NSTimeInterval timeInterval;
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *createdAtDate;
        for (RetrieveInboxEntity *inboxEntity in lReturn) {
            createdAtDate = [self getCurrentTimeZoneDateAndTimeFromDate:[formatter dateFromString:inboxEntity.createdAt]];
            timeInterval = [[NSDate date] timeIntervalSinceDate:createdAtDate];
            NSInteger hours = [self getHoursFromTimeInterval:timeInterval];
            if (hours > 24 && ([inboxEntity.status isEqualToString:@"RCV"] || [inboxEntity.type isEqualToString:@"outgoing"])) {
                [[CoreDataManager instance].managedObjectContext deleteObject:inboxEntity];
            } else {
            RetrieveInbox *inboxItem = [MTLManagedObjectAdapter modelOfClass:[RetrieveInbox class] fromManagedObject:inboxEntity error:&lError];
            [self.inbox addObject:inboxItem];
            }
        }
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
        self.inbox = [NSMutableArray arrayWithArray:[self.inbox sortedArrayUsingDescriptors:sortDescriptors]];
        if(self.inbox.count < limit) {
            self.totalPages = self.currentPage;
        }
        
        completion();
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }];
}

- (NSDate *)getCurrentTimeZoneDateAndTimeFromDate:(NSDate *)date {
    NSDate* currentDate = date;
    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    NSDate* nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    return nowDate;
}

- (NSInteger)getHoursFromTimeInterval:(NSTimeInterval)timeInterval {
    return timeInterval / 3600;
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setBackgroundColor:[UIColor colorWithRed:247.f / 255.f green:247.f / 255.f blue:247.f / 255.f alpha:1.f]];
    
    //    [self.refreshControl setBackgroundColor:[UIColor clearColor]];
    
    [self.refreshControl setClipsToBounds:YES];
    [self.refreshControl setTintColor:[UIColor clearColor]];
    //    [self.refreshControl addTarget:self
    //                            action:@selector(refreshView:)
    //                  forControlEvents:UIControlEventTouchDown];
    
    
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
    if(![self checkInternet]) {
        [refresh endRefreshing];
        return;
    }
    
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
    
    [self deleteAllInbox];
    // 
    //    [self.tableView reloadData];
    
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
   // double delayInSeconds = 5.0; // number of seconds to wait
    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,  NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self updateInboxWithLimit:25 page:0 completion:^{
            [refresh endRefreshing];
            self.tableView.scrollEnabled = YES;
            self.tableView.allowsSelection = YES;
            
            [self.arrowImageView.layer removeAnimationForKey:@"rotationAnimation"];
            [self.attributedLabel setText:@"Pull down to update"];
            [self.arrowImageView setImage:[UIImage imageNamed:@"lovebox-icon-arrowdown"]];
        }];
        
    
        
 //   });
}

- (void)deleteInboxOlderThen24Hours {
    
}

- (void)deleteAllInbox {
    [self.inbox removeAllObjects];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RetrieveInbox"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [[CoreDataManager instance].persistentStoreCoordinator executeRequest:delete withContext:[CoreDataManager instance].managedObjectContext error:&deleteError];
}

@end
