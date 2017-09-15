//
//  ChangeLanguageViewController.m
//  LoveScore
//
//  Created by Vasyl Khmil on 11/10/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ChangeLanguageViewController.h"
#import "ChangeLanguageTableViewCell.h"
#import "Global.h"
#import "NavigationTitle.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"

@interface ChangeLanguageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)NSArray *languages;
@property (strong, nonatomic)NSArray *languagesFlags;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end


@implementation ChangeLanguageViewController


#pragma mark - View Controller life cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"CHANGE LANGUAGE" withRedWord:@"LANGUAGE"];
    
    ///
    self.languages = [NSArray arrayWithObjects:@"Deutsch", @"Français", @"Español", @"U.S. English", @"U.K. English", nil];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChangeLanguageTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ChangeLanguageTableViewCell class])];
    
    UIImage *deutschFlagImg = [UIImage imageNamed:@"germanFlag"];
    UIImage *frenchFlagImg = [UIImage imageNamed:@"FranceFlag"];
    UIImage *spanishFlagImg = [UIImage imageNamed:@"SpainFlag"];
    UIImage *usaFlagImg = [UIImage imageNamed:@"USAFlag"];
    UIImage *ukFlagImg = [UIImage imageNamed:@"UKFlag"];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];

    self.languagesFlags = [NSArray arrayWithObjects:deutschFlagImg, frenchFlagImg, spanishFlagImg, usaFlagImg, ukFlagImg,nil];
    

}


#pragma mark - Table View Data Source

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.languages.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    ChangeLanguageTableViewCell *cell = (ChangeLanguageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChangeLanguageTableViewCell class])];
    
    cell.languageName.text = [self.languages objectAtIndex:indexPath.row];
    [cell.languageImage setImage:[self.languagesFlags objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

#pragma mark - Properties

- (void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    tableView.tableFooterView = [UIView new];
    
    self.tableView.backgroundColor =[UIColor clearColor];
}
#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark IBActions

@end
