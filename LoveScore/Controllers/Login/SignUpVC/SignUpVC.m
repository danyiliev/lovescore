//
//  SignUpVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SignUpVC.h"
#import "SignInVC.h"
#import "UIColor+ColorAdditions.h"
#import "UIImage+ImageAdditions.h"
#import "UserServices.h"
#import "TTTAttributedLabel.h"
#import "NSMutableAttributedString+ColorfulText.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "ExtendedButton.h"
#import "SearchTableVC.h"
#import "DataStore.h"
#import "DataStoreEntity.h"
#import "DataStoreServices.h"
#import "CoreDataManager.h"
#import "SyncManager.h"
#import "AddGirlsServices.h"
#import "SideMenuModel.h"
#import "User.h"
#import "UserEntity.h"

@interface SignUpVC () <UITextFieldDelegate, SearchTableProtocol>

@property (strong, nonatomic) IBOutlet TTTAttributedLabel *logoLabel;

@property (weak, nonatomic) IBOutlet UILabel *acceptLabel;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UISwitch *confirmSwitch;
@property (strong, nonatomic) IBOutlet UIButton *countryButton;

@property (nonatomic, strong) UserServices *userServices;
@property (nonatomic, strong) DataStoreServices *dataStoreImpl;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomLogoHeightConstraint;
@property (weak, nonatomic) IBOutlet ExtendedButton *signUpButton;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) SyncManager *syncManager;

@property (nonatomic, strong) NSString *countryName;

@end

@implementation SignUpVC

#pragma mark - init and systems methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoLabel.numberOfLines = 0;
    self.countryName = @"";
    
    NSString *lString = self.logoLabel.text;
    
    self.confirmSwitch.layer.cornerRadius = self.confirmSwitch.frame.size.height / 2;
    self.confirmSwitch.layer.masksToBounds = NO;
    NSMutableAttributedString *confitmTitle = [[NSMutableAttributedString alloc] initWithString:@"I accept Terms and Conditions and confirm that I am 13 years or over"];
    [confitmTitle setColorForText:@"Terms and Conditions" withColor:RED_COLOR];
    UIFont *font = [UIFont fontWithName:@"Lato-Regular" size:14.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    [confitmTitle addAttributes:attrsDictionary range:NSRangeFromString(@"I accept Terms and Conditions and confirm that I am 13 years or over")];
    self.acceptLabel.attributedText = confitmTitle;
    
    [self.logoLabel setText:lString afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange redRange = [lString rangeOfString:@"Love"];
        if (redRange.location != NSNotFound) {
            
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RED_COLOR.CGColor range:redRange];
        }
        
        return mutableAttributedString;
    }];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithImage:[UIImage imageNamed:@"bg-intro"] scaledToSize:self.view.frame.size]];
    
    self.userServices = [[UserServices alloc]init];
    
    self.dataStoreImpl  = [DataStoreServices new];
    
    [self setupTextFields];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Private mehods

- (void)setupTextFields {
    [self.usernameTextField setDelegate:self];
    [self.usernameTextField setReturnKeyType:UIReturnKeyDone];
    [self.usernameTextField addTarget:self
                               action:@selector(dismissKeyboard)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.passwordTextField setDelegate:self];
    [self.passwordTextField setReturnKeyType:UIReturnKeyDone];
    [self.passwordTextField addTarget:self
                               action:@selector(dismissKeyboard)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.emailTextField setDelegate:self];
    [self.emailTextField setReturnKeyType:UIReturnKeyDone];
    [self.emailTextField addTarget:self
                            action:@selector(dismissKeyboard)
                  forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (NSDictionary *)getCountriesFromDataStore {
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
    
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    
    if ([[SyncManager sharedInstance] connected]) {
        if (lReturn.count > 0) {
            DataStoreEntity *data = (DataStoreEntity *)lReturn[0];
            DataStore *dataStore = [MTLManagedObjectAdapter modelOfClass:[DataStore class] fromManagedObject:data error:&lError];
            
            if (lError != nil) {
                NSLog(@"%@ %s %@", self.class, __func__, lError.description);
            }
            
            NSDictionary *countriesDictionary = [dataStore.internationalisation objectForKey:@"countries"];
            
            return countriesDictionary;
            
        } else {
            
            [[self.dataStoreImpl getDataStore] subscribeCompleted:^(void) {
                
            }];
        }
    } else {
        [self showAlertControllerWithTitle:@"Warning" withMessage:@"Check your inernet connection."];
        [[SyncManager sharedInstance] setCheckForDataStore:YES];
    }
    
    return nil;
}

#pragma mark - actions

- (IBAction)signUpButtonAction:(id)sender {
    
    [self dismissKeyboard];

    if (self.confirmSwitch.isOn) {
        if ([[SyncManager sharedInstance] connected]) {
            
            @weakify(self);
            [[self.userServices registrationWithUsername:self.usernameTextField.text
                                                password:self.passwordTextField.text
                                                   email:self.emailTextField.text
                                                 country:self.countryName]
             
             subscribeNext:^(id x) {
                 @strongify(self);
                 
                 if ([self validateData:x]) {
                     dispatch_async(dispatch_get_main_queue(), ^(void) {
                         [self loginAction];
                     });
                 }
             }];
        } else {
            [self showAlertControllerWithTitle:@"Warning" withMessage:@"Check your inernet connection."];
        }
    } else {
        [self showAlertControllerWithTitle:@"" withMessage:@"You must agree to the Terms & Conditions and prove that you are 13 and over before register."];
    }
}

- (void)loginAction {
    
    if ([[SyncManager sharedInstance] connected]) {
        
        @weakify(self);
        [[self.userServices loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text] subscribeCompleted:^(void) {
            @strongify(self);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AllowSideMenu];
                [SideMenuModel sharedInstance];
            });
            
            [[self.userServices retrieveUserDetails] subscribeCompleted:^(void) {
                
                NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
                
                NSError *lError = nil;
                NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
                
                UserEntity *userEntity = (UserEntity *)lReturn[0];
                User *user = [MTLManagedObjectAdapter modelOfClass:[User class] fromManagedObject:userEntity error:&lError];
                
                if (user.displayName && user.displayName.length > 0) {
                    
                    [[SideMenuModel sharedInstance] setName:user.displayName];
                } else {
                    [[SideMenuModel sharedInstance] setName:user.username];
                }
            }];
        }];
    } else {
        [self showAlertControllerWithTitle:@"Warning" withMessage:@"Check your inernet connection."];
        [[SyncManager sharedInstance] setCheckForDataStore:YES];
    }
}

- (IBAction)switchToSignInVC:(UIButton *)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

#pragma mark - SearchTableProtocol

- (void)stringWasSelected:(NSString *)string {
    self.countryName = string;
    
    NSDictionary *dictionary = [self getCountriesFromDataStore];
    [self.countryButton setTitle:[dictionary objectForKey:string] forState:UIControlStateNormal];
    [self.countryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - Keyboard

- (void)keyboardWillShow {
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    [self setViewMovedUp:YES];
}

-(void)keyboardWillHide {
    
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    [self setViewMovedUp:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)sender {
    
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp {
    
    if (movedUp){
        if ([UIScreen mainScreen].bounds.size.width <= 320) {
            self.bottomLogoHeightConstraint.constant = 0;
        }
        
        self.heightConstraint.constant = 0;
        
    } else {
        if ([UIScreen mainScreen].bounds.size.width <= 320) {
            self.bottomLogoHeightConstraint.constant = 10.f;
        }
        
        self.heightConstraint.constant = 56.f;
    }
    
    [UIView animateWithDuration:8.f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (BOOL)validateData:(NSDictionary *)data {
    BOOL isValid = YES;
    
    NSInteger errorCode = [[data objectForKey:@"code"] integerValue];
    switch (errorCode) {
        case 202: {
            NSArray *arr = [data objectForKey:@"data"];
            NSDictionary *dict = [arr objectAtIndex:0];
            NSString *usernameInfo = [dict objectForKey:@"username"];
            NSString *countryInfo = [dict objectForKey:@"country"];
            NSString *emailInfo = [dict objectForKey:@"email"];
            NSString *passwordInfo = [dict objectForKey:@"password"];
            
            if (usernameInfo) {
                isValid = NO;
                [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Wrong username format."];
            } else if (countryInfo) {
                isValid = NO;
                [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Wrong country format."];
            } else if (emailInfo) {
                isValid = NO;
                [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Wrong email format."];
            } else if (passwordInfo) {
                isValid = NO;
                [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Insufficient password security."];
            }
        }
            break;
        case 203: {
            [self showAlertControllerWithTitle:@"Warning!" withMessage:@"This username is already taken."];
            isValid = NO;
        }
            break;
        case 204: {

            [self showAlertControllerWithTitle:@"Warning!" withMessage:@"The email address you entered is already in use on another LoveScore account."];
            isValid = NO;
        }
            break;
        case 205: {
            
            [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Insufficient password security."];
            isValid = NO;
        }
            break;
        case 206: {

            [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Registration of user has failed."];
            isValid = NO;
        }
            break;
        case 207: {

            [self showAlertControllerWithTitle:@"Warning!" withMessage:@"Registration of user has failed."];
            isValid = NO;
        }
            break;

        default: {
        }
            break;
    }
    
    return isValid;
}

- (IBAction)termsAndConditionsTapped:(id)sender {
    
}

- (IBAction)countryButtonAction:(id)sender {
    
    SearchTableVC *vc = [SearchTableVC new];
    vc.searchDictionary = [self getCountriesFromDataStore];
    vc.delegate = self;
    if (vc.searchDictionary) {
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self showAlertControllerWithTitle:@"Warning" withMessage:@"Check your inernet connection."];
    }
}

@end
