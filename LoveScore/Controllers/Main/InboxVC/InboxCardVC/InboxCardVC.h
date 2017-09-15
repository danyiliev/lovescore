//
//  InboxCardVC.h
//  LoveScore
//
//  Created by админ on 11/10/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "CardModel.h"

@interface InboxCardVC : UIViewController
@property (strong, nonatomic)Person *person;
//@property (strong, nonatomic)NSString *ident;
@property (strong, nonatomic)CardModel *card;

@end
