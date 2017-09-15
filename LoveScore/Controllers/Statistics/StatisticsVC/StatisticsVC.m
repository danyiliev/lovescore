//
//  StatisticsVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/6/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "StatisticsVC.h"
#import "SideMenuModel.h"
#import "Global.h"
#import "TTTAttributedLabel.h"
#import "TTTAttributedLabel + ColorText.h"

@interface StatisticsVC () {
    
}

@end

@implementation StatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.title = @"STATISTICS MY";
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"STATISTICS" withRedWord:@""];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)callSideMenu:(UIBarButtonItem *)sender {
    [[SideMenuModel sharedInstance] anchorRight];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentedControlValueChange:(id)sender {
    UISegmentedControl *segmentedControl = sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:{
            [_statisticsView setHidden:NO];
            [_recordsView setHidden:YES];
            break;
        }
        case 1:{
            [_recordsView setHidden:NO];
            [_statisticsView setHidden:YES];
        }
    }
}


//set tittle with red color;

@end
