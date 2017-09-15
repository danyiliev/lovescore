//
//  WorldScoreVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"



@interface WorldScoreVC : UIViewController

@property (nonatomic, strong)NSArray *girls;
@property (nonatomic, strong)DataStore *dataStore;

@end
