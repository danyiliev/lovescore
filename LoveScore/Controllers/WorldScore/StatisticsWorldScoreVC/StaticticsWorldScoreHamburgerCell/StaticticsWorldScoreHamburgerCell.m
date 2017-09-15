//
//  StaticticsWorldScoreHamburgerCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/28/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//
#define ROWS_COUNT 3

#import "StaticticsWorldScoreHamburgerCell.h"
#import "SmallCell.h"
#import "Statistic.h"

@interface StaticticsWorldScoreHamburgerCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;


@end

@implementation StaticticsWorldScoreHamburgerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 80.0 + ROWS_COUNT * 57);
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SmallCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SmallCell class])];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.contentSize.height);
    [self.tableView setUserInteractionEnabled:YES];
}

- (void)layoutSubviews
{
    if ([[UIScreen mainScreen] bounds].size.width < 370) {
        self.progressViewWidth.constant = 105;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _amountOfCells = self.statistics.count;
    return self.statistics.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SmallCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SmallCell class])];
    
    NSArray *countries = [self.statistics allKeys];
    [cell setCountryName:[countries objectAtIndex:indexPath.row]];
    [cell setFlagImageWithCountryName:[countries objectAtIndex:indexPath.row]];
    [cell setUserInteractionEnabled:YES];
    Statistic *statistic = [self.statistics objectForKey:[countries objectAtIndex:indexPath.row]];
    
    [cell setNumberOfGirlsWithLoveEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithLoveEvent] kissEvent:[NSNumber numberWithInteger:statistic.numberOfGirlsWithKissEvent] averageRating:[NSNumber numberWithFloat:statistic.averageRating]];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)setCountOfGirls:(NSInteger)countOfGirls numberOfAllGirls:(NSInteger)numberOfAllGirls {
    self.numberOfGirlsLable.text = [NSString stringWithFormat:@"%li of %li",(long)countOfGirls,(long)numberOfAllGirls];
}
- (IBAction)act:(id)sender {
    
}

@end
