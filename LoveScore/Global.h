//
//  Global.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/21/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#ifndef Global_h
#define Global_h

#define VIEW_CONTROLLER_WITH_STORYBOARD_AND_ID(storyboardName,identifier) (UIViewController *)[[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:identifier];

#define APP_DELEGATE (AppDelegate*)[UIApplication sharedApplication].delegate

#define RED_COLOR [UIColor colorWithRed:216.0 / 255.0f green:49.0 / 255.0f blue:48.0 / 255.0f alpha:1]
#define LIGHT_GREY_COLOR [UIColor colorWithRed:247.0 / 255.0f green:247.0 / 255.0f blue:247.0 / 255.0f alpha:1]

#define DARK_COLOR [UIColor colorWithRed:52.f / 255.0f green:52.f / 255.0f blue:52.f / 255.0f alpha:1]

#define FB_UserInfo @"FbUserInfo"
#define AllowSideMenu @"AllowSideMenu"


#endif /* Global_h */

#define changesWithGirlsNotification @"changesInGirlsArray"

#define TermsAndConditions
 
// ------------------- global enums --------------------

typedef enum {
    CellColorLighter = 0,
    CellColorDarker
} CellColor;


typedef enum {
    StoryTypeChat = 0,
    StoryTypeKiss,
    StoryTypeLove
}StoryType;


typedef enum {
    NotificationEventTypeInboxItemReceived = 0,
    NotificationEventTypeFriendRequestCreated,
    NotificationEventTypeFriendRequestDeclined,
    NotificationEventTypeFriendRequestAccepted,
    NotificationEventTypeUnknown
} NotificationEventType;

