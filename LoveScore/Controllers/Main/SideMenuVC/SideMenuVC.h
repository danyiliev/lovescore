//
//  SideMenuVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef  enum {
    AddGirlSideMenuElement = 0,
    MyGirlSideMenuElement,
    WorldScoreSideMenuElement,
    StaticsSideMenuElement,
//    LuckyListSideMenuElement,     Marked by Dany Iliev, 21.08/2017 18:54:00
    InboxSideMenuElement,
    FriendsSideMenuElement
}SideMenuElement;

@interface SideMenuVC : UIViewController

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic) BOOL newInbox;
@property (nonatomic) BOOL newFriend;

- (void)performSegueWithID:(NSString *)identifier;

@end
