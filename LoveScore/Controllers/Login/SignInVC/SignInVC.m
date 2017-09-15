//
//  SignInVC.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SignInVC.h"
#import "UIColor+ColorAdditions.h"
#import "UIImage+ImageAdditions.h"
#import "TTTAttributedLabel.h"
#import "SignUpVC.h"
#import <ReactiveCocoa/RACEXTScope.h>

#import "UserServices.h"
#import "AddGirlsServices.h"

#import <AFNetworking/AFNetworking.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "User.h"
#import "CoreDataManager.h"

#import "SyncManager.h"
#import "PicturesEntity.h"
#import "ImageManager.h"

#import "UserEntity.h"
#import "User.h"
#import "SideMenuModel.h"

#import <Crashlytics/Crashlytics.h>

@interface SignInVC () <UserServicesDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *logoLabel;

@property (nonatomic, strong) UserServices *userServices;
@property (nonatomic, strong) AddGirlsServices *addGirlsServices;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (strong, nonatomic) IBOutlet UIView *fbButtonView;
    
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation SignInVC

#pragma mark - init and system methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.userServices = [[UserServices alloc] init];
    self.addGirlsServices = [AddGirlsServices new];
    
    self.logoLabel.numberOfLines = 0;
    
    NSString *lString = self.logoLabel.text;
    
    [self.logoLabel setText:lString afterInheritingLabelAttributesAndConfiguringWithBlock:^(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange redRange = [lString rangeOfString:@"Love"];
        if (redRange.location != NSNotFound) {
            
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RED_COLOR.CGColor range:redRange];
        }
        
        return mutableAttributedString;
    }];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithImage:[UIImage imageNamed:@"bg-intro"] scaledToSize:self.view.frame.size]];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self setupTextFields];
    
    self.userServices.delegate = self;

    self.switchToSignUpButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.switchToSignUpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [UIView performWithoutAnimation:^{
        [self.switchToSignUpButton setTitle:@"No account yet?\nSign up - It's 100% free!" forState:UIControlStateNormal];
        [self.switchToSignUpButton layoutIfNeeded];
    }];
    
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

#pragma mark - Private methods

- (void) setupTextFields {
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
}

- (BOOL)validateFBUserData:(NSDictionary *)data {
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
//        case 203: {
//            [self showAlertControllerWithTitle:@"Warning!" withMessage:@"This username is already taken."];
//            isValid = NO;
//        }
//            break;
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

#pragma  mark - actions

- (void)loginAction:(NSString *)username password:(NSString *)pass photo:(NSString *)urlString{
    
    if ([[SyncManager sharedInstance] connected]) {
        @weakify(self);
        [[self.userServices loginWithUsername:username password:pass] subscribeCompleted:^(void) {
            @strongify(self);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                
                [[SyncManager sharedInstance] downloadPersonsInfo];
            });
            
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
                
                user.avatarUrl = urlString;
                
                if (user.displayName && user.displayName.length > 0) {
                    
                    [[SideMenuModel sharedInstance] setName:user.displayName];
                } else {
                    [[SideMenuModel sharedInstance] setName:user.username];
                }
                
                if (user.avatarUrl && user.avatarUrl.length > 0) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                        UIImage *avatarImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatarUrl]]];
                        
                        [[ImageManager sharedInstance] saveUserAvatar:avatarImage];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            [[SideMenuModel sharedInstance] setAvatar:avatarImage];
                        });
                    });
                }
            }];
        }];
    } else {
        [self showErrorMessage:@"Check your internet connection"];
        [[SyncManager sharedInstance] setCheckForDataStore:YES];
    }
}

- (void)loginViaFB{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"email,first_name,last_name,locale,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            NSLog(@"%@", result);
            
            NSString *email, *username, *password, *country, *imageStringOfLoginUser;
            NSString *shortid;
            
            // email
            if ([result valueForKey:@"email"] && [[result valueForKey:@"email"] length] > 0)
                email = [result valueForKey:@"email"];
            else
                email = @"";
            
            // username
            if (([result valueForKey:@"last_name"] && [[result valueForKey:@"last_name"] length] > 0) &&
                ([result valueForKey:@"id"] && [[result valueForKey:@"id"] length] > 0)){
                shortid = [[result valueForKey:@"id"] substringToIndex:3];
                username = [NSString stringWithFormat:@"%@%@",
                            [result valueForKey:@"last_name"], shortid];
            }else
                username = @"";
            
            // password
            password = @"facebook123";
            
            // country
            if ([result valueForKey:@"locale"] && [[result valueForKey:@"locale"] length] > 0){
                NSArray *comp = [[result valueForKey:@"locale"] componentsSeparatedByString:@"_"];
                if (comp && comp.count > 0)
                    country = comp[1];
            }
            else
                country = @"GB";
            
            // image
            if ([[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"])
                imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
            else
                imageStringOfLoginUser = @"";
            
            if ([[SyncManager sharedInstance] connected]) {

                @weakify(self);
                [[self.userServices registrationWithUsername:username
                                                    password:password
                                                       email:email
                                                     country:country]
                 subscribeNext:^(id x) {
                     @strongify(self);
                     if ([self validateFBUserData:x]) {
                         
                         [[NSUserDefaults standardUserDefaults] setObject:result forKey:FB_UserInfo];
                         [[NSUserDefaults standardUserDefaults] synchronize];

                         dispatch_async(dispatch_get_main_queue(), ^(void) {
                             [self loginAction:username password:password photo:imageStringOfLoginUser];
                         });
                     }
                 }];
            } else {
                [self showAlertControllerWithTitle:@"Warning" withMessage:@"Check your inernet connection."];
            }
        }
    }];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [self dismissKeyboard];
    
    [self loginAction:_usernameTextField.text password:_passwordTextField.text photo:nil];
 }

- (IBAction)loginFBButtonPressed:(id)sender{
    if ([FBSDKAccessToken currentAccessToken]) {
        NSDictionary *result = [[NSUserDefaults standardUserDefaults] objectForKey:FB_UserInfo];
        NSString *username, *password, *imageStringOfLoginUser;
        NSString *shortid;

        // username
        if (([result valueForKey:@"last_name"] && [[result valueForKey:@"last_name"] length] > 0) &&
            ([result valueForKey:@"id"] && [[result valueForKey:@"id"] length] > 0)){
            shortid = [[result valueForKey:@"id"] substringToIndex:3];
            username = [NSString stringWithFormat:@"%@%@",
                        [result valueForKey:@"last_name"], shortid];
        }else
            username = @"";
        
        // password
        password = @"facebook123";
        
        // image
        if ([[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"])
            imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
        else
            imageStringOfLoginUser = @"";
        
        [self loginAction:username password:password photo:imageStringOfLoginUser];
    }else{
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"email"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                NSLog(@"Process error");
            } else if (result.isCancelled) {
                NSLog(@"Cancelled");
            } else {
                NSLog(@"Logged in");
                
                if ([result.grantedPermissions containsObject:@"email"]){
                    NSLog(@"result is:%@",result);
                }
                
                [self loginViaFB];
            }
        }];
    }
}

- (IBAction)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}

- (IBAction)switchToSignUpVC:(UIButton *)sender {
//    SignUpVC *viewController = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SignUpVC"];
    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
//    
    //    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    //    [self.navigationController presentViewController:viewController animated:NO completion:nil];
}

#pragma mark - APIHTTPAlertDelegate

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

#pragma mark - UITextFieldDelegate

- (void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - Keyboard

- (void)keyboardWillShow {
    [self setViewMovedUp:YES];
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)keyboardWillHide {
    [self setViewMovedUp:NO];
    
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
}

- (void)textFieldDidBeginEditing:(UITextField *)sender {
    
}

//method to move the view up/down whenever the keyboard is shown/dismissed
- (void)setViewMovedUp:(BOOL)movedUp {
    
    if ([UIScreen mainScreen].bounds.size.width <= 320) {
        
        if (movedUp){
            self.heightConstraint.constant = 0;
        } else {
            self.heightConstraint.constant = 66.f;
        }
        
        [UIView animateWithDuration:8.f
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
    }
}

@end
