//
//  SearchTableVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/23/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"

@protocol SearchTableProtocol <NSObject>

- (void)stringWasSelected:(NSString *)string;

@end

@interface SearchTableVC : UIViewController

@property (weak, nonatomic) id<SearchTableProtocol> delegate;
@property (strong, nonatomic) NSArray *searchValuesArray;
@property (strong, nonatomic) NSDictionary *searchDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *preselectedValue;
@property (strong, nonatomic)DataStore *dataStore;
@property (strong, nonatomic)NSString *titleString;
@end
