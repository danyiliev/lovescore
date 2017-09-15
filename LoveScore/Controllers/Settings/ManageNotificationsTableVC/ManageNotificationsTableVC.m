//
//  ManageNotificationsTableVC.m
//  LoveScore
//
//  Created by Taras Pasichnyk on 10/13/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ManageNotificationsTableVC.h"
#import "SideMenuModel.h"
#import "NavigationTitle.h"
#import "Global.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"
#import "SpecialsCellWithSwitch.h"
#import "UIView+ViewCreator.h"
#import "UserServices.h"

@interface ManageNotificationsTableVC () <SpecialsCellWithSwitchDelegate>

@property (strong, nonatomic)NSArray *notificationTitles;

@property (strong, nonatomic) UserServices *userServices;
@property (strong, nonatomic) NSDictionary *notificationsDict;
@property (strong, nonatomic) NSMutableDictionary *params;

@end

@implementation ManageNotificationsTableVC

#pragma mark - constants

static NSString* const FontForHeaderInSections = @"Lato-Bold";

#pragma mark - TableViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notificationTitles = @[
                                @"New card",
                                @"New friend request",
                                @"Friend request accepted",
                                @"Friend request declined"
                                ];
    self.notificationsDict = @{
                               @"New card" : @"newCard",
                               @"New friend request" : @"newFriendRequest",
                               @"Friend request accepted" : @"friendRequestAccepted",
                               @"Friend request declined" : @"friendRequestDeclined"
                               };
    self.params = [NSMutableDictionary new];

    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"MANAGE NOTIFICATION" withRedWord:@"NOTIFICATION"];
    self.userServices = [UserServices new];
    [self getNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self.userServices uploadNotificationSettings:self.params] subscribeNext:^(id x) {
        
    }error:^(NSError *error) {
        
    } ];
}

- (IBAction)callSideMenu:(UIBarButtonItem *)sender {
    [[SideMenuModel sharedInstance] anchorRight];
}

#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notificationTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecialsCellWithSwitch *cell = [tableView dequeueReusableCellWithIdentifier:SpecialsCellWithSwitchId];
    
    if (!cell) {
        cell = [SpecialsCellWithSwitch createView];
    }
    [cell setParameterName:[self.notificationTitles objectAtIndex:indexPath.row]];
    if (self.params.count > 0) {
        BOOL switchIsTurnOn = [[self.params objectForKey:[self.notificationsDict objectForKey:self.notificationTitles[indexPath.row]]] boolValue];
        [cell setIsSwitchTurnOn:switchIsTurnOn];
    }
//    } else {
//    if ([cell isSwitchTurnOn]) {
//        [self.params setObject:[NSNumber numberWithBool:YES] forKey:[self.notificationsDict objectForKey:self.notificationTitles[indexPath.row]]];
//    } else {
//        [self.params setObject:[NSNumber numberWithBool:NO] forKey:[self.notificationsDict objectForKey:self.notificationTitles[indexPath.row]]];
//    }
//    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

#pragma mark - Private methods

- (void)getNotifications {
    [[self.userServices retrieveUserDetails] subscribeNext:^(id x) {
        NSMutableDictionary *params = [[x objectForKey:@"notifications"] mutableCopy];
        if (params.count > 0) {
            self.params = params;
        } else {
            self.params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                          @"newCard" : [NSNumber numberWithBool:YES],
                                                                          @"newFriendRequest" : [NSNumber numberWithBool:YES],
                                                                          @"friendRequestAccepted" : [NSNumber numberWithBool:YES],
                                                                          @"friendRequestDeclined" : [NSNumber numberWithBool:YES]
                                                                          
                            }];
        }
        [self.tableView reloadData];
    }];
    
}

#pragma mark - Special cell delegate

- (void)switchWasTurnOn:(NSString *)parameterName {
    [self.params setObject:[NSNumber numberWithBool:YES] forKey:[self.notificationsDict objectForKey:parameterName]];
}

- (void)switchWasTurnOff:(NSString *)parameterName {
    [self.params setObject:[NSNumber numberWithBool:NO] forKey:[self.notificationsDict objectForKey:parameterName]];
}

#pragma mark Bar Buttons Actions

- (void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
