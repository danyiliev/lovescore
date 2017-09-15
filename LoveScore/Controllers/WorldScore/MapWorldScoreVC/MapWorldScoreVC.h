//
//  MapWorldScoreVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "FSInteractiveMapView.h"


@interface MapWorldScoreVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong)NSDictionary *continents;
@property (nonatomic, strong) FSInteractiveMapView *map;

@property (strong, nonatomic)NSArray *girls;
@property (nonatomic, strong) DataStore *dataStore;

@end
