//
//  SearchFriendsVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/4/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SearchFriendsVC.h"
#import "SearchFriendsCell.h"
#import "UIView+ViewCreator.h"
#import "FriendsServices.h"
#import "UINavigationItem+CustomBackButton.h"
#import "Friend.h"
#import "SideMenuModel.h"

@interface SearchFriendsVC () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)UISearchController *searchController;

@property (strong, atomic) NSMutableArray *potentialFriendsArray;

@property (strong, nonatomic) NSMutableArray *incomingFriendsArray;
@property (strong, nonatomic) NSMutableArray *outgoingFriendsArray;

@property (nonatomic, strong) dispatch_queue_t concurrentPhotoQueue; ///queue for barrirer where two read threads will be read


@property (strong, nonatomic) FriendsServices *friendsServices;

@end

@implementation SearchFriendsVC

#pragma mark - life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.incomingFriendsArray = [NSMutableArray new];
    self.outgoingFriendsArray = [NSMutableArray new];
    
    self.potentialFriendsArray = [NSMutableArray new];
    
    self.friendsServices = [[FriendsServices alloc]init];

    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    [self configureSearchController];
    
    [self getFriendsRequest];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.potentialFriendsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchFriendsCellId];
    
    if (!cell) {
        cell = [SearchFriendsCell createView];
    }
    
    //    NSString *userName = ([(NSDictionary *)self.potentialFriendsArray[indexPath.row] objectForKey:@"username"]);
    
    Friend *friend = ((Friend *)self.potentialFriendsArray[indexPath.row]);
    
    NSString *username = friend.username;
    
    [cell setUsername:username];
    
    
    switch (friend.friendState) {
        case FriendStateIncoming: {
            [cell setFriendState:FriendsCellStateAdd];
        }
            break;
        case FriendStateOutcoming: {
            [cell setFriendState:FriendsCellStateSentRequest];
        }
            break;
        case FriendStatePotential: {
            [cell setFriendState:FriendsCellStateNotAdded];
        }
            break;
        case FriendStateCurrentFriend: {
            [cell setFriendState:FriendsCellStateNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchFriendsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Friend *selectedFriend = (Friend *)self.potentialFriendsArray[indexPath.row];
    
    
    if (cell.friendState == FriendsCellStateNotAdded) {
        [[self.friendsServices createFriendsRequest:cell.username] subscribeCompleted:^(void) {
            selectedFriend.friendState = FriendStateOutcoming;
            [tableView reloadData];
        }];
    } else
        
        if (cell.friendState == FriendsCellStateAdd) {
            
            UIAlertController *actionController = [UIAlertController
                                                   alertControllerWithTitle:nil
                                                   message:nil
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *acceptAction = [UIAlertAction
                                           actionWithTitle:@"Accept friend request"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               @weakify(self);
                                               [[self.friendsServices acceptFriendsRequest:cell.username] subscribeCompleted:^(void) {
                                                   @strongify(self);
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       selectedFriend.friendState = FriendStateCurrentFriend;
                                                       [self.currentFriendsArray addObject:selectedFriend];
                                                       [self.potentialFriendsArray removeObjectAtIndex:indexPath.row];
                                                       
                                                       [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                                                    

                                                       NSLog(@"accept user %@ friend request", cell.username);
                                                   });
                                                  
                                               }];
                                               
                                           }];
            
            UIAlertAction *rejectAction = [UIAlertAction
                                           actionWithTitle:@"Reject friend request"
                                           style:UIAlertActionStyleDestructive
                                           handler:^(UIAlertAction *action)
                                           {
                                               [[self.friendsServices rejectFriendsRequest:cell.username] subscribeCompleted:^(void) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       selectedFriend.friendState = FriendStatePotential;
                                                       [cell setFriendState:FriendsCellStateNotAdded];
                                                       NSLog(@"reject user %@ frined request", cell.username);
                                                   });
                                                   [self getFriendsRequest];
                                               }];
                                           }];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action) {
                                               
                                           }];
            
            
            [actionController addAction:acceptAction];
            [actionController addAction:rejectAction];
            [actionController addAction:cancelAction];
            
            [self presentViewController:actionController animated:YES completion:nil];
            actionController.view.tintColor = RED_COLOR;
        } else
            
            if (cell.friendState == FriendsCellStateSentRequest) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *actionController = [UIAlertController
                                                           alertControllerWithTitle:@"Friend request!"
                                                           message:@"You have sent friend request to this user."
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *cancelAction = [UIAlertAction
                                                   actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
                    
                    UIAlertAction *cancelFriendAction = [UIAlertAction
                                                         actionWithTitle:@"Cancel friend request"
                                                         style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             [[self.friendsServices cancelFriendsRequest:cell.username] subscribeCompleted:^(void) {
                                                                 selectedFriend.friendState = FriendStatePotential;
                                                                 [cell setFriendState:FriendsCellStateNotAdded];
                                                                 
                                                             }];
                                                         }];
                    
                    [actionController addAction:cancelAction];
                    [actionController addAction:cancelFriendAction];
                    
                    [self presentViewController:actionController animated:YES completion:nil];
                    actionController.view.tintColor = RED_COLOR;
                });
            }
    
    //    if (![self.searchController.searchBar.text isEqualToString:@""]) {
    //
    ////        [self getFriendsRequest];
    //        [self filterContentForTerm:self.searchController.searchBar.text];
    //    } else {
    //        [self getFriendsRequest];
    //    }
    
}

#pragma mark - Search bar controller

- (void)filterContentForTerm:(NSString*)searchText {
    NSLog(@"searchText - %@", searchText);
    
    if (searchText.length >= 3) {
        @weakify(self);
        [[self.friendsServices searchUsers:searchText] subscribeNext:^(id x) {
            @strongify(self);
            NSArray *array = x;
            
            for (int i = 0; i < array.count; i++) {
                Friend *friend = [Friend new];
                friend.username = ([(NSDictionary *)array[i] objectForKey:@"username"]);
                
                if (([(NSDictionary *)array[i] objectForKey:@"display_name"]) != nil) {
                    friend.displayName = ([(NSDictionary *)array[i] objectForKey:@"display_name"]);
                }
                
                BOOL wasFound = NO;
                for (int i = 0; i < self.potentialFriendsArray.count; i++) {
                    if ([((Friend *)self.potentialFriendsArray[i]).username isEqualToString:friend.username]) {
                        wasFound = YES;
                        break;
                    }
                }
                
                for (int i = 0; i < self.currentFriendsArray.count; i++) {
                    if ([((Friend *)self.currentFriendsArray[i]).username isEqualToString:friend.username]) {
                        wasFound = YES;
                        break;
                    }
                }
                
                if (!wasFound) {
                    friend.friendState = FriendStatePotential;
                    [self.potentialFriendsArray insertObject:friend atIndex:0];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForTerm:searchController.searchBar.text];
}

#pragma mark - Private methods

- (void)configureSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.tintColor = RED_COLOR;
    
    self.tableView.tableHeaderView = _searchController.searchBar;
}

- (void)getFriendsRequest {
    
    [self.potentialFriendsArray removeAllObjects];
    [self.incomingFriendsArray removeAllObjects];
    [self.outgoingFriendsArray removeAllObjects];
    
    @weakify(self);
    [[self.friendsServices getIncomingFriendsWithLimit:@"50" andWithPage:@"0" savingToDatabase:YES] subscribeNext:^(id responseObject) {
        @strongify(self);
        
        NSDictionary *dictionaryResponseObject = responseObject;
        
        NSArray *array = [dictionaryResponseObject objectForKey:@"data"];
        
        for (int i = 0; i < array.count; i++) {
            Friend *friend = [Friend new];
            friend.username = ([(NSDictionary *)array[i] objectForKey:@"username"]);
            
            if (([(NSDictionary *)array[i] objectForKey:@"display_name"]) != nil) {
                friend.displayName = ([(NSDictionary *)array[i] objectForKey:@"display_name"]);
            }
            
            friend.friendState = FriendStateIncoming;
            
            [self.incomingFriendsArray addObject:friend];
        }
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // barrier for reading friends
            [self.potentialFriendsArray addObjectsFromArray:self.incomingFriendsArray];
            
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username"
                                                         ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            self.potentialFriendsArray = [[self.potentialFriendsArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
        
    }];
    
    [[self.friendsServices getOutgoingFriendsWithLimit:@"50" andWithPage:@"0"] subscribeNext:^(id responseObject) {
        
        NSDictionary *dictionaryResponseObject = responseObject;
        
        NSArray *array = [dictionaryResponseObject objectForKey:@"data"];
        
        for (int i = 0; i < array.count; i++) {
            Friend *friend = [Friend new];
            friend.username = ([(NSDictionary *)array[i] objectForKey:@"username"]);
            
            if (([(NSDictionary *)array[i] objectForKey:@"display_name"]) != nil) {
                friend.displayName = ([(NSDictionary *)array[i] objectForKey:@"display_name"]);
            }
            
            friend.friendState = FriendStateOutcoming;
            
            [self.outgoingFriendsArray addObject:friend];
        }
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self.potentialFriendsArray addObjectsFromArray:self.outgoingFriendsArray];
            
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username"
                                                         ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            self.potentialFriendsArray = [[self.potentialFriendsArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }];
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
    
}
- (void)didPresentSearchController:(UISearchController *)searchController {
    
}
- (void)willDismissSearchController:(UISearchController *)searchController {
    
    [self getFriendsRequest];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    
}

@end
