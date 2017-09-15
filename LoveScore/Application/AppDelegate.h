//
//  AppDelegate.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OneSignal/OneSignal.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary *timersDictionary;
@property (strong, nonatomic) NSMutableDictionary *timeDictionary;
@property (nonatomic) NSInteger index;
@property (strong, nonatomic)NSString *myGirlsSortType;
@property (strong, nonatomic)NSString *luckyListSortType;
@property (strong, nonatomic) OneSignal *oneSignal;
@property (assign, nonatomic) BOOL newCardNotificationEnable;
@property (assign, nonatomic) BOOL newFriendNotificationEnable;
@property (assign, nonatomic) BOOL acceptFriendNotificationEnable;
@property (assign, nonatomic) BOOL declineFriendNotificationEnable;



- (void)deleteOneSignalTags;

@end

