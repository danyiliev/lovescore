//
//  SendToVC.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface SendToVC : UIViewController

@property (nonatomic, strong) Person *person;

@property (nonatomic)BOOL isTeaserCard;
@property (nonatomic)BOOL isFullCard;

@end
