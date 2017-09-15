//
//  StatisticScoreVCViewController.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 3/16/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"

@interface StatisticScoreVC : UIViewController
@property (nonatomic, strong)DataStore *dataStore;
@property (nonatomic, strong) NSArray *girls;
@end
