//
//  StatisticsVC.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *statisticsView;
@property (weak, nonatomic) IBOutlet UIView *recordsView;

- (IBAction)segmentedControlValueChange:(id)sender;

@end
