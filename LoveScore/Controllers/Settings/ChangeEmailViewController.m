//
//  ChangeEmailViewController.m
//  LoveScore
//
//  Created by Vasyl Khmil on 11/11/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ChangeEmailViewController.h"
#import "TTTAttributedLabel + ColorText.h"
#import "UINavigationItem+CustomBackButton.h"
#import "CoreDataManager.h"
#import "UserServices.h"
#import "User.h"
#import "UserEntity.h"

NSString * const verifiedEmail = @"Your email address is verified";
NSString * const notVerifiedEmail = @"Your email address is not verified";

@interface ChangeEmailViewController ()

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;

@end

@implementation ChangeEmailViewController

#pragma mark - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [UINavigationItem makeLeftArrowBarButtonInNavigationItem:self selector: @selector(backBarButtonAction)];
    
    self.navigationItem.titleView = [TTTAttributedLabel getString:@"CHANGE EMAIL" withRedWord:@"EMAIL"];
    
    if (self.user.email && self.user.email.length > 0) {
        [self.emailTextField setText:self.user.email];
    }
}

#pragma mark Bar Buttons Actions

-(void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions

- (IBAction)saveBarButtonPressed:(id)sender {
//    if ([self validateName:self.emailTextField.text]) {
    
        UserServices *userServices = [UserServices new];
        
        [[userServices updateUserDetailsWithField:@"email" value:self.emailTextField.text]
         
         subscribeError:^(NSError *error) {
             
             [self showErrorMessage:@"Operation couldn't be done."];
         } completed:^(void) {
             
             self.user.email = self.emailTextField.text;
             NSError *error = nil;
             
             [MTLManagedObjectAdapter managedObjectFromModel:self.user
                                        insertingIntoContext:[[CoreDataManager instance] managedObjectContext]
                                                       error:&error];
             [[CoreDataManager instance] saveContext];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self dismissViewControllerAnimated:YES completion:nil];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             });
         }
         ];
//    }
}

- (IBAction)screenTapped{
    [self.view endEditing:YES];
}


- (IBAction)editingChanged:(UITextField *)sender {
    if ([self isValidEmail:self.emailTextField.text]) {
        [self.statusLabel setText:verifiedEmail];
        [self.statusLabel setTextColor:[UIColor colorWithRed:126.f/ 255.f green:211.f / 255.f blue:33.f/255.f alpha:1.f]];
        self.saveBarButton.enabled = YES;
    } else {
        [self.statusLabel setText:notVerifiedEmail];
        [self.statusLabel setTextColor:[UIColor redColor]];
        self.saveBarButton.enabled = NO;
    }
}

#pragma mark - Public methods

- (void)setUser:(User *)user {
    _user = user;
}

#pragma mark - Private methods

- (BOOL)isValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO;
    
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)validateName:(NSString *)name {
    BOOL validationResult = YES;
    
    NSString *errorMessage;
    
    NSUInteger nameLength = name.length;
    
    if (nameLength < 2 || nameLength > 25) {
        validationResult = NO;
        errorMessage = @"Wrong email length";
    }
    
    for (int i = 0; i < nameLength; i++) {
        int character = [name characterAtIndex:i];
        
        if ((character >= 65 && character <= 90) || (character >= 97 && character <= 122) || character == 32) {
            
        } else {
            validationResult = NO;
            errorMessage = @"Using wrong symbols";
        }
    }
    
    if (!validationResult) {
        [self showErrorMessage:errorMessage];
    }
    
    return validationResult;
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


@end
