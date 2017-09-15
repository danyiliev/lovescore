//
//  PrivacyVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/13/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "PrivacyVC.h"
#import "TTTAttributedLabel + ColorText.h"

@interface PrivacyVC ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation PrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.titleView = [TTTAttributedLabel getString:@"PRIVACY POLICY" withRedWord:@"POLICY"];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLayoutSubviews {
    [self.textView setContentOffset:CGPointZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
