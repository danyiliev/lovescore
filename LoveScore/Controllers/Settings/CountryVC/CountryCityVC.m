//
//  CountryVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/2/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "Global.h"
#import "CountryCityVC.h"
#import "NavigationTitle.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"

@interface CountryCityVC ()

@property (strong, nonatomic) NSArray *countriesArray;

@end

@implementation CountryCityVC



#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"CHANGE COUNTRY" withRedWord:@"COUNTRY"];

    
    //
    self.countriesArray = @[@"United States", @"United Kingdom", @"Canada", @"Australia",@"Japan", @"Germany", @"Ukraine", @"Italy", @"Sweden", @"New Zealand"];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return  self.countriesArray.count;
}
#pragma mark - Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"CountryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reuseId];
    }
 
    cell.textLabel.text = [self.countriesArray objectAtIndex:indexPath.row];
    
    return cell;
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 51.0f;
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
