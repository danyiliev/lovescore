//
//  MyCountryWorldScoreVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"


@interface MyCountryWorldScoreVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *girls;
@property (strong, nonatomic)DataStore *dataStore;


@end
