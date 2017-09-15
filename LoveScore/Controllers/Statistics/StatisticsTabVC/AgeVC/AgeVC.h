//
//  AgeVC.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h> 

typedef NS_ENUM(NSInteger, AgeRanges) {
    between18And20 = 0,
    between20And30,
    between30And40,
    between40And50,
    moreThen50
};

@interface AgeVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
