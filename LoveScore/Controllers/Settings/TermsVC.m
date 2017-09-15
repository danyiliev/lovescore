//
//  TermsVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/13/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "TermsVC.h"
#import "TTTAttributedLabel + ColorText.h"

@interface TermsVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end

@implementation TermsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.navItem.titleView = [TTTAttributedLabel getString:@"TERMS & CONDITIONS" withRedWord:@"CONDITIONS"];
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
