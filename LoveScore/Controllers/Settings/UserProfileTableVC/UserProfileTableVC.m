//
//  UserProfileTableViewController.m
//  LoveScore
//
//  Created by Taras Pasichnyk on 10/12/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "UserProfileTableVC.h"
#import "SideMenuModel.h"
#import "NavigationTitle.h"
#import "TTTAttributedLabel + ColorText.h"
#import "Global.h"
#import "AppDelegate.h"
#import "UserProfileCell.h"
#import "SpecialsCellWithSwitch.h"
#import "UIView+ViewCreator.h"
#import "SearchTableVC.h"

#import "UserServices.h"
#import "UserProfileProtocol.h"
#import "User.h"
#import "UserEntity.h"

#import "CoreDataManager.h"
#import "DataStore.h"
#import "DataStoreEntity.h"

#import "ImageManager.h"
#import "SideMenuModel.h"

#import "SearchCityVC.h"
#import "AppDelegate.h"

#import <SSKeychain/SSKeychainQuery.h>
#import <SSKeychain/SSKeychain.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface UserProfileTableVC ()<SpecialsCellWithSwitchDelegate, SearchTableProtocol, SearchCityProtocol>

@property (nonatomic, strong) NSArray *sectionsArray;
@property (nonatomic, strong) NSArray *myAccountRowName;

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSDictionary *countriesDictionary;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation UserProfileTableVC

#pragma mark - constants

static NSString* const FontForHeaderInSections = @"Lato-Bold";

#pragma mark - TableViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countriesDictionary = [self getCountriesFromDataStore];
    self.appDelegate = APP_DELEGATE;
//    
//    UserServices *userServices = [UserServices new];
//    
//    [[userServices retrieveUserDetails] subscribeCompleted:^(void) {
//        
//    }];
    
    [self setupConstants];
    
    self.user = [[CoreDataManager instance] getUser];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"SETTINGS" withRedWord:@""];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"WasWiped"]) {
    //        [self logOut];
    //    }
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.currentIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (IBAction)callSideMenu:(UIBarButtonItem *)sender {
    [[SideMenuModel sharedInstance] anchorRight];
}

#pragma mark - Table view data source and delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 53.0)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(8, 17, sectionHeaderView.frame.size.width, 19.0)];
    
    UIFont *font = [UIFont fontWithName:@"Lato-Bold" size:16.0];
    UIColor *textColor = RED_COLOR;
    NSDictionary *textAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:textColor};
    
    //        NSAttributedString *headerText = [[NSAttributedString alloc] initWithString:[self tableView:tableView titleForHeaderInSection:section] attributes:textAttributes];
    
    NSAttributedString *headerText = [[NSAttributedString alloc] initWithString:self.sectionsArray[section] attributes:textAttributes];
    
    headerLabel.attributedText = headerText;
    [headerLabel sizeToFit];
    
    [sectionHeaderView addSubview:headerLabel];
    
    return  sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 53.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2.0f;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 51.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    switch (section) {
        case 0: {
            numberOfRows = 5;
        }
            break;
            
        case 1: {
            numberOfRows = 2;
        }
            break;
        case 2: {
            numberOfRows = 2;
        }
            break;
            
        case 3: {
            numberOfRows = 2;
        }
            break;
            
        case 4: {
            numberOfRows = 1;
        }
        default:
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        SpecialsCellWithSwitch *cell = [tableView dequeueReusableCellWithIdentifier:SpecialsCellWithSwitchId];
        
        if (!cell) {
            cell = [SpecialsCellWithSwitch createView];
        }
        
        cell.delegate = self;
        
        [cell setParameterName:@"Receive notifications"];
        
        
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            [cell setIsSwitchTurnOn:YES];
        } else {
            [cell setIsSwitchTurnOn:NO];
        }
        
        return cell;
        
    } else {
        UserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:SpecialsCellWithSwitchId];
        
        if (!cell) {
            cell = [UserProfileCell createView];
        }
        
        switch (indexPath.section) {
            case 0: {
                switch (indexPath.row) {
                    
                    case 0: {
                        [cell setInfo:self.user.username];
                    }
                        break;
                        
                    case 1: {
                        [cell setInfo:self.user.email];
                    }
                        break;
                        
                    case 2: {
                        
                        [cell setInfo:[self.countriesDictionary objectForKey:self.user.country]];
                    }
                        break;
                    case 3: {
                        if (self.user.city && ![[self.user.city objectForKey:@"name"] isEqual:[NSNull null]]) {
                            [cell setInfo:[self.user.city objectForKey:@"name"]];
                        } else {
                            [cell setInfo:@""];
                        }
                    }
                        break;
                    case 4: {
                        [cell setInfo:@""];
                    }
                        break;
                    case 5: {
                        [cell setInfo:self.user.language];
                    }
                        break;
                    default:
                        break;
                }
                
                [cell setName:self.myAccountRowName[indexPath.row]];
            }
                break;
                
            case 1: {
                [cell setName:@"Manage notifications"];
                [cell setInfo:@""];
            }
                break;
                
            case 2: {
                if (indexPath.row == 0) {
                    [cell setName:@"LoveScore passcode"];
                    [cell setInfo:@""];
                } else {
                    [cell setName:@"Wipe account data"];
                    [cell setInfo:@""];
                }
            }
                break;
                
            case 3: {
                if (indexPath.row == 0) {
                    [cell setName:@"Privacy"];
                    [cell setInfo:@""];
                } else {
                    [cell setName:@"Terms & conditions"];
                    [cell setInfo:@""];

                }
                break;

            case 4: {
                    [cell setName:@"Log out of this device"];
                    [cell setInfo:@""];
                }
            }
            default:
                break;
        }
        return cell;
    }
    
    return  nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
            
                case 0: {
                    [self performSegueWithIdentifier:@"usernameSegueIdentifier" sender:self];
                }
                    break;
                    
                case 1: {
                    [self performSegueWithIdentifier:@"emailSegueIdentifier" sender:self];
                }
                    break;
                    
                case 2: {
                    //country
                    SearchTableVC *vc = [SearchTableVC new];
                    vc.searchValuesArray = [[self getCountriesFromDataStore] allValues];
                    vc.delegate = self;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case 3: {
                    // city
                    if (self.user.country && self.user.country.length > 0) {
                        SearchCityVC *vc = [SearchCityVC new];
                        vc.country = self.user.country;
                        vc.delegate = self;
                        [self.navigationController pushViewController:vc animated:YES];
                    } else {
                        [self showErrorMessage:@"You should select some country before."];
                    }
                }
                    break;
                case 4: {
                    
                    [self performSegueWithIdentifier:@"changePasswordSegueIdentifier" sender:self];
                }
                    break;
                case 5: {
                    // language
                }
                    break;
                default:
                    break;
            }
            self.currentIndexPath = indexPath;
        }
            break;
            
        case 1: {
            if (indexPath.row == 1) {
                [self performSegueWithIdentifier:@"notificationSegueIdentifier" sender:self];
            }
        }
            break;
            
        case 2: {
            if (indexPath.row == 0) {
                
                NSString *password = [SSKeychain passwordForService:@"lovescore" account:self.user.username];
                
                if (password && password.length == 4) {
                    [self performSegueWithIdentifier:@"changePasscodeSegueIdentifier1" sender:self];
                } else {
                    [self performSegueWithIdentifier:@"createPasscodeSegueIdentifier" sender:self];
                }
                
                //app passcode
            } else {
                // wipe account
                
                if ([[SyncManager sharedInstance] connected]) {
                    [self performSegueWithIdentifier:@"wipeSegueIdentifier" sender:self];
                } else {
                    [self showErrorMessage:@"Check internet connetion."];
                }
            }
        }
            break;
            
        case 3: {
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"PrivacyIdentifier" sender:self];
            }
            if (indexPath.row == 1) {
                [self performSegueWithIdentifier:@"TermsIdentifier" sender:self];
            }
            break;
        case 4: {
                //logout functionality
                [[SyncManager sharedInstance] logOut];
            
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [FBSDKProfile setCurrentProfile:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Private methods

-(void)setupConstants {
    self.sectionsArray = [[NSArray alloc]initWithObjects:@"MY ACCOUNT", @"NOTIFICATIONS", @"SECURITY", @"LEGAL", @"LOG OUT", nil];
    
    self.myAccountRowName = [[NSArray alloc]initWithObjects: @"Username", @"Email", @"My country", @"My city", @"Password", @"Language", nil];
}

- (NSDictionary *)getCountriesFromDataStore {
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
    
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    
    NSDictionary *countriesDictionary = nil;
    if (lReturn && lReturn.count > 0) {
        DataStoreEntity *data = (DataStoreEntity *)lReturn[0];
        DataStore *dataStore = [MTLManagedObjectAdapter modelOfClass:[DataStore class] fromManagedObject:data error:&lError];
        
        if (lError != nil) {
            NSLog(@"%@ %s %@", self.class, __func__, lError.description);
        }
        
        countriesDictionary = [dataStore.internationalisation objectForKey:@"countries"];
    }
    
    //    NSArray *countriesArray = [countriesDictionary allValues];
    //    return countriesArray;
    
    return  countriesDictionary;
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

#pragma mark - SpecialsCellWithSwitchDelegate
- (void)switchWasTurnOn:(NSString *)parameterName {
  
    if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
- (void)switchWasTurnOff:(NSString *)parameterName {
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

#pragma  mark - SearchTableProtocol

- (void)stringWasSelected:(NSString *)string {

    NSArray *temp = [self.countriesDictionary allKeysForObject:string];
    NSString *key = [temp objectAtIndex:0];
    
    UserServices *userServices = [UserServices new];
    
    [[userServices updateUserDetailsWithField:@"country" value:key]
     subscribeError:^(NSError *error) {
         
         [self showErrorMessage:@"Operation couldn't be done."];
     } completed:^(void) {
         
         self.user.country = key;
         
         NSError *error = nil;
         
         [MTLManagedObjectAdapter managedObjectFromModel:self.user
                                    insertingIntoContext:[[CoreDataManager instance] managedObjectContext]
                                                   error:&error];
         [[CoreDataManager instance] saveContext];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self.tableView beginUpdates];
             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.currentIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
             [self.tableView endUpdates];
         });
     }
     ];
}

#pragma mark - Search city protocol
- (void)cityWasSelected:(NSDictionary *)city {
    UserServices *userServices = [UserServices new];
    
    NSString *cityId = [city objectForKey:@"place_id"];
    
    [[userServices updateUserDetailsWithField:@"city_place_id" value:cityId]
     subscribeError:^(NSError *error) {
         
         [self showErrorMessage:@"Operation couldn't be done."];
     } completed:^(void) {
         
         self.user.city = city;
         NSError *error = nil;
         
         [MTLManagedObjectAdapter managedObjectFromModel:self.user
                                    insertingIntoContext:[[CoreDataManager instance] managedObjectContext]
                                                   error:&error];
         [[CoreDataManager instance] saveContext];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self.tableView beginUpdates];
             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.currentIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
             [self.tableView endUpdates];
             
         });
     }
     ];
}
#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"nameSegueIdentifier"]) {
        UIViewController<UserProfileProtocol> *vc = segue.destinationViewController;
        vc.user = self.user;
    }
    if ([segue.identifier isEqualToString:@"usernameSegueIdentifier"]) {
        UIViewController<UserProfileProtocol> *vc = segue.destinationViewController;
        vc.user = self.user;
        
    }
    if ([segue.identifier isEqualToString:@"emailSegueIdentifier"]) {
        UIViewController<UserProfileProtocol> *vc = segue.destinationViewController;
        vc.user = self.user;
        
    }
    if ([segue.identifier isEqualToString:@"changePasswordSegueIdentifier"]) {
        UIViewController<UserProfileProtocol> *vc = segue.destinationViewController;
        vc.username = self.user.username;
    }
    if ([segue.identifier isEqualToString:@"notificationSegueIdentifier"]) {
    }
    
    if ([segue.identifier isEqualToString:@"createPasscodeSegueIdentifier"] || [segue.identifier isEqualToString:@"changePasscodeSegueIdentifier1"]) {
        UIViewController<UserProfileProtocol> *vc = segue.destinationViewController;
        
        vc.username = self.user.username;
    }
    
    if ([segue.identifier isEqualToString:@"wipeSegueIdentifier"]) {
        UIViewController<UserProfileProtocol> *vc = segue.destinationViewController;
        
        vc.username = self.user.username;
    }
}

-(void)wipedAccount {
    
}


@end

