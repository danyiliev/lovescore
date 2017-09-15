//
//  WipeFinishVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/20/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "WipeFinishVC.h"
#import "Global.h"
#import "NavigationTitle.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"
#import "UserServices.h"
#import "ImageManager.h"
#import "CoreDataManager.h" 
#import "SideMenuModel.h"

@interface WipeFinishVC ()
@property (strong, nonatomic) IBOutlet UISwitch *firstSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *secondSwitch;

@end

@implementation WipeFinishVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"WIPE ACCOUNT" withRedWord:@"ACCOUNT"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)screenTapped{
    [self.view endEditing:YES];
}

- (IBAction)finishButtonAction:(id)sender {
    UserServices *userSI = [UserServices new];
    
    if (self.firstSwitch.isOn && self.secondSwitch.isOn) {
        [[userSI wipeUserAcount] subscribeError:^(NSError *error) {

            [self showErrorMessage:@"Operation couldn't be done."];
        } completed:^(void) {
            [self logOut];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WasWiped"];

//            if ([self.delegate respondsToSelector:@selector(wipedAcccount)]) {
//                [self.delegate wipedAcccount];
//            }
        }];
    } else {
        [self showErrorMessage:@"Select switches"];
    }
}

- (void)logOut {
    
    [[SyncManager sharedInstance] logOut];
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showErrorMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Warning!"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *showWarningAction = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction *action)
                                        {
                                            
                                        }];
    
    [alertController addAction:showWarningAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    alertController.view.tintColor = RED_COLOR;
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
