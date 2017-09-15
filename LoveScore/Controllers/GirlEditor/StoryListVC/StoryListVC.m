//
//  StoryListVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "StoryListVC.h"

@interface StoryListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *storiesArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation StoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.navigationController.navigationBar.translucent = NO;
    
    self.storiesArray = [[NSArray alloc]initWithObjects:@"Being the savage's bowsman, that is, the person who pulled the bow-oar in his boat (the second one from forward).", @"Being the savage's bowsman, that is, the person who pulled the bow-oar in his boat (the second one from forward), it was my cheerful duty to attend upon him while taking that hard-scrabble scramble upon the dead whale's back. You have seen Italian.", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource, UITableViewDelegate delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storiesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, [UIScreen mainScreen].bounds.size.width - 66, 17)];
    
    [commentLabel setText:self.storiesArray[indexPath.row]];
    [commentLabel setNumberOfLines:0];
    [commentLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14.f]];
    
    [commentLabel sizeToFit];
    
    return commentLabel.frame.size.height + 32;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryListVCId"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StoryListVCId"];
    }
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, [UIScreen mainScreen].bounds.size.width - 66, 17)];

    [commentLabel setNumberOfLines:0];
    [commentLabel setText:self.storiesArray[indexPath.row]];
    
    [commentLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14.f]];
    
    [commentLabel sizeToFit];
    
    [cell addSubview:commentLabel];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width - 34 - 16, commentLabel.frame.size.height / 2 - 2, 34, 34)];
    [deleteButton setImage:[UIImage imageNamed:@"history-icon-delete"] forState:UIControlStateNormal];
    
    [cell addSubview:deleteButton];
    
//    [cell layoutSubviews];
    
    return cell;
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
