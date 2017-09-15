//
//  RecordsTabVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordsTabVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
