//
//  AppDelegate.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "AppDelegate.h"
#import "DataStore.h"
#import "DataStoreEntity.h"
#import "DataStoreServices.h"
#import "CoreDataManager.h"
#import "User.h"
#import "UserEntity.h"
#import "APIHTTPClient.h"

#import "SyncManager.h"
#import "ImageManager.h"

#import <SSKeychain/SSKeychainQuery.h>
#import <SSKeychain/SSKeychain.h>
#import "UserProfileProtocol.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <NewRelicAgent/NewRelic.h>
#import "SideMenuModel.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface AppDelegate ()

@property (assign, nonatomic)BOOL userIsExist;

@end

@implementation AppDelegate

//appId:@"74692f0d-a062-464d-b8be-529e7576a853" - Swopti
//appId:@"69ef8c49-f5cc-4532-aae2-96859d5de8c2" - Tim
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    
    self.oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions
                                                        appId:@"0cdb92fa-0a74-433d-9752-93d7048f8681"
                                           handleNotification:^(NSString* message, NSDictionary* additionalData, BOOL isActive) {
                                               NSString *eventTypeString = [additionalData objectForKey:@"event_type"];
                                               __block NotificationEventType eventType;
                                               
                                               __block NSString *seagueId = nil;
                                               __block NSString *firstMessage = nil;
                                               
                                               if ([eventTypeString isEqualToString:@"inbox_item_received"]) {
                                                   eventType = NotificationEventTypeInboxItemReceived;
                                                   seagueId = @"InboxNavigationControllerSegue";
                                                   firstMessage = @"Please open the inbox and refresh it";
                                                   [[SideMenuModel sharedInstance] sideMenuVC].newInbox = YES;
                                               }
                                               if ([eventTypeString isEqualToString:@"friend_request_created"]) {
                                                   eventType = NotificationEventTypeFriendRequestCreated;
                                                   [[SideMenuModel sharedInstance] sideMenuVC].newFriend = YES;
                                                   seagueId = @"@Friends";
                                                   firstMessage = @"Please open the screen to see all pending friend requests";
                                               }
                                               
                                               if ([eventTypeString isEqualToString:@"friend_request_declined"]) {
                                                   eventType = NotificationEventTypeFriendRequestDeclined;
                                                   seagueId = @"@Friends";
                                                   firstMessage = @"Please open friends view";
                                               }
                                               
                                               if ([eventTypeString isEqualToString:@"friend_request_accepted"]) {
                                                   eventType = NotificationEventTypeFriendRequestAccepted;
                                                   seagueId = @"@Friends";
                                                   firstMessage = @"Please open friends view";
                                               }
                                               
                                               if (isActive) {
                                                   
                                                   UIAlertAction *openAction = [UIAlertAction
                                                                                actionWithTitle:@"Open"
                                                                                style:UIAlertActionStyleDefault
                                                                                handler:^(UIAlertAction *action)
                                                                                {[((SideMenuModel *)[SideMenuModel sharedInstance]).slidingViewController resetTopViewAnimated:NO];
                                                                                    [((SideMenuModel *)[SideMenuModel sharedInstance]).sideMenuVC performSegueWithID:seagueId];
                                                                                }];
                                                   
                                                   UIAlertAction *cancelAction = [UIAlertAction
                                                                                  actionWithTitle:@"Cancel"
                                                                                  style:UIAlertActionStyleCancel
                                                                                  handler:nil];
                                                   
                                                   NSArray *actionsArray = [[NSArray alloc] initWithObjects:openAction, cancelAction, nil];
                                                   
                                                   [self.window.rootViewController showAlertControllerWithTitle:@"Notification" withMessage:[NSString stringWithFormat:@"%@\n%@", message, firstMessage] andWithActions:actionsArray];
                                               } else {
                                                   
                                                   [((SideMenuModel *)[SideMenuModel sharedInstance]).slidingViewController resetTopViewAnimated:NO];
                                                   [((SideMenuModel *)[SideMenuModel sharedInstance]).sideMenuVC performSegueWithID:seagueId];
                                               }
                                               
                                               NSLog(@"OneSignal Notification opened:\nMessage: %@", message);
                                               
                                               if (additionalData) {
                                                   
                                                   NSLog(@"additionalData: %@", additionalData);
                                                   
                                                   NSString* customKey = additionalData[@"customKey"];
                                                   if (customKey) {
                                                       NSLog(@"customKey: %@", customKey);
                                                   }
                                               }
                                           }];
    
    [self.oneSignal registerForPushNotifications];
    //  [self.oneSignal enableInAppAlertNotification:true];
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:RED_COLOR];
    
    self.timersDictionary = [NSMutableDictionary new];
    self.timeDictionary = [NSMutableDictionary new];
    
    //setApplicationId:@"fynbd5OTIOLKUs29KzXLzxGRyUBMaEt34SlLxh20"
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    [SyncManager sharedInstance];
    
    if ([[SyncManager sharedInstance] connected]) {
        [self getDataStore];
    } else {
        [SyncManager sharedInstance].checkForDataStore = YES;
        [self checkForUserExistanse];
    }
    if (self.userIsExist) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"customLaunchScreen"];
        self.window.rootViewController = viewController;
    }
    
    // Facebook SDK
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[CoreDataManager instance] saveContext];
    
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSError *error = nil;
    
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&error];
    
    if (lReturn && lReturn.count > 0) {
        NSError *lError;
        UserEntity *userEntity = (UserEntity *)lReturn[0];
        User *user = [MTLManagedObjectAdapter modelOfClass:[User class] fromManagedObject:userEntity error:&lError];
        
        if (lError != nil) {
            NSLog(@"%@ %s %@", self.class, __func__, lError.description);
        }
        
        NSString *password = [SSKeychain passwordForService:@"lovescore" account:user.username];
        if (password && password.length == 4) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            
            UIViewController<UserProfileProtocol> *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"PasscodeId"];
            initViewController.username = user.username;
            
            [self.window.rootViewController presentViewController:initViewController animated:NO completion:nil];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return handled;
}
    
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [ImageManager resetImageManager];
    
    //    [[ImageManager sharedInstance] saveKeys];
    [[CoreDataManager instance] saveContext];
    
}

#pragma mark - Private methods


- (void)getDataStore {
    
    DataStoreServices *dataStore = [[DataStoreServices alloc]init];
    dispatch_sync( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        @weakify(self);
        [[dataStore getDataStore] subscribeCompleted:^(void) {
            @strongify(self);
            [self checkForUserExistanse];
        }];
    });
}

- (void)checkForUserExistanse {
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSError *error = nil;
    
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&error];
    
    if (lReturn && lReturn.count > 0) {
        self.userIsExist = YES;
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        
        [[APIHTTPClient sharedAPIHTTPClient].requestSerializer setValue:token forHTTPHeaderField:@"X-LoveScore-Token"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSError *lError;
            UserEntity *userEntity = (UserEntity *)lReturn[0];
            User *user = [MTLManagedObjectAdapter modelOfClass:[User class] fromManagedObject:userEntity error:&lError];
            
            // place to send a tags
            [self.oneSignal sendTags:@{@"language" : @"en", @"username" : user.username}];
            
            if (lError != nil) {
                NSLog(@"%@ %s %@", self.class, __func__, lError.description);
            }
            
            [SideMenuModel sharedInstance];
            
            NSString *password = [SSKeychain passwordForService:@"lovescore" account:user.username];
            
            if (password && password.length == 4) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    
                    UIViewController<UserProfileProtocol> *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"PasscodeId"];
                    initViewController.username = user.username;
                    
                    [self.window.rootViewController presentViewController:initViewController animated:NO completion:nil];
                });
            }
        });
    }
}


- (void)deleteOneSignalTags {
    [self.oneSignal deleteTags:@[@"language", @"username"]];
}

@end
