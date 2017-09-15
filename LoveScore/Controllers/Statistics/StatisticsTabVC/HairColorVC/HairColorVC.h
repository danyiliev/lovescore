//
//  HairColorVC.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/1/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HairColorVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
