//
//  SideMenuModel.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/8/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SideMenuModel.h"
#import "AppDelegate.h"

#import "CoreDataManager.h"
#import "User.h"
#import "UserEntity.h"
#import "ImageManager.h"

@interface SideMenuModel () {
    BOOL _isOpen;
}

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgeGestureRecognizer;
@property (nonatomic, strong) UIView *crossView;

@property (nonatomic, strong) UIView *currentView;

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

@end

@implementation SideMenuModel

#pragma mark - Init methods

static SideMenuModel *sharedInstance = nil;

+ (SideMenuModel *)sharedInstance {
    
    if (sharedInstance == nil && [[NSUserDefaults standardUserDefaults] boolForKey:AllowSideMenu]) {
        sharedInstance = [[SideMenuModel alloc] init];
    }
    return sharedInstance;
}

+ (void)resetSharedInstance {
    
    sharedInstance = nil;
}

- (void)reset {
    
    [self.slidingViewController.topViewController removeFromParentViewController];
    [self.slidingViewController removeFromParentViewController];
    [self.sideMenuVC removeFromParentViewController];
    
    self.slidingViewController.topViewController = nil;
    self.slidingViewController = nil;
    self.sideMenuVC = nil;
}

- (id)init {

    if (self = [super init]) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MyGirlNavigationControllerId"];
        self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:controller];
        
        UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.sideMenuVC = (SideMenuVC *)[secondStoryboard instantiateViewControllerWithIdentifier:@"SlideVCId"];
        
        NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        
        NSError *lError = nil;
        NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
        
        // TODO:remove this from here
        
        if (lReturn && lReturn.count > 0) {
            
            UserEntity *userEntity = (UserEntity *)lReturn[0];
            User *user = [MTLManagedObjectAdapter modelOfClass:[User class] fromManagedObject:userEntity error:&lError];
            
            if (user.displayName && user.displayName.length > 0) {
                
                [self.sideMenuVC setUserName:user.displayName];
            } else {
                [self.sideMenuVC setUserName:user.username];
            }
            
            if (lError != nil) {
                NSLog(@"%@ %s %@", self.class, __func__, lError.description);
            }
        }
        
        self.slidingViewController.underLeftViewController = self.sideMenuVC;
        
        self.slidingViewController.anchorRightRevealAmount = [UIScreen mainScreen].bounds.size.width - 55.f;
                
        AppDelegate *appDelegate = (AppDelegate *) 	[[UIApplication sharedApplication] delegate];
        
//        appDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        appDelegate.window.rootViewController = self.slidingViewController;
        [appDelegate.window makeKeyAndVisible];
        
        _isOpen = NO;
        
        UIImage *avatarImage = [[ImageManager sharedInstance] getUserAvatarImage];
        
        if (avatarImage) {
            [self setAvatar:avatarImage];
        }
        
    }
    return self;
}

#pragma mark - Public methods

- (void)setAvatar:(UIImage *)image {
    if (image) {
        [self.sideMenuVC setAvatarImage:image];
    }
}

- (void)setName:(NSString *)name {
    if (name && name.length > 0) {
        [self.sideMenuVC  setUserName:name];
    }
}

- (void)anchorRight {
    
    
    if (_isOpen) {
        
        [self.rightView removeGestureRecognizer:self.swipeGestureRecognizer];
        [self.rightView removeGestureRecognizer:self.tapGestureRecognizer];
        [self.rightView removeFromSuperview];
        
        [self.slidingViewController resetTopViewAnimated:YES];
//        [self.currentView setUserInteractionEnabled:YES];
    } else {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
//        [self.currentView setUserInteractionEnabled:NO];
        
        self.rightView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 55, 0, 55, [UIScreen mainScreen].bounds.size.height)];
        
        // add gesture for close side menu
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(anchorRight)];
        [self.rightView addGestureRecognizer:self.tapGestureRecognizer];
        
        self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(anchorRight)];
        self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.rightView addGestureRecognizer:self.swipeGestureRecognizer];
        
        [self.slidingViewController.containerView addSubview:self.rightView];
    }

    // change state from "Open" to "Close" or vice versa
    [self changeSideMenuState];
}

- (void)changeSideMenuState {
    _isOpen = !_isOpen;
}

- (void)addEdgeSwipeOnView:(UIView *)view {
    self.edgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(anchorRight)];
    [self.edgeGestureRecognizer setEdges:UIRectEdgeLeft];
    [view addGestureRecognizer:self.edgeGestureRecognizer];
    self.currentView = view;
}

- (void)removeEdgeSwipeFromView:(UIView *)view {
    [view removeGestureRecognizer:self.edgeGestureRecognizer];
}

- (void)performSegueWithID:(NSString *)identifier withSender:(id)sender {
    [self.sideMenuVC performSegueWithIdentifier:identifier sender:self.sideMenuVC];
}

@end
