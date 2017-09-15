//
//  InboxTeaserCardVC.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/4/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "CardModel.h"

@interface InboxTeaserCardVC : UIViewController

@property (strong, nonatomic)NSString *ident;
@property (strong, nonatomic)Person *person;
@property (strong, nonatomic)CardModel *card;


@end
