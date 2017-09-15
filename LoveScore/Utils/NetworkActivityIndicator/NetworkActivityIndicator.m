//
//  NetworkActivityIndicator.m
//  MoveboxTF
//
//  Created by  Кирилл Легкодух on 06.10.15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "NetworkActivityIndicator.h"
#import "MBProgressHUD.h"


@interface NetworkActivityIndicator ()

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) NSInteger loaderCount;

@end

@implementation NetworkActivityIndicator

+ (instancetype)sharedNetworkActivityIndicator
{
    static NetworkActivityIndicator *_sharedInstance;
    if (!_sharedInstance) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedInstance = [[super alloc] initPrivate];
        });
    }
    
    return _sharedInstance;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[NetworkActivityIndicator sharedNetworkManager]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - Loader

- (void)showLoader {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud == nil) {
            
            UIView *currentView = [[[UIApplication sharedApplication] windows] lastObject];
            self.hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
            self.hud.mode = MBProgressHUDModeIndeterminate;
            self.hud.color = [UIColor colorWithRed:40.f/255.f green:40.f/255.f blue:40.f/255.f alpha:0.9f];
            self.hud.activityIndicatorColor = [UIColor redColor];
            
        }
        self.loaderCount += 1;
        //NSLog(@"Loader++  = %i", self.loaderCount);
        [self.hud show:YES];
    });
}

- (void)showLoaderWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud == nil) {
            
            UIView *currentView = [[[UIApplication sharedApplication] windows] lastObject];
            self.hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
            self.hud.mode = MBProgressHUDModeIndeterminate;
            self.hud.color = [UIColor colorWithRed:40.f/255.f green:40.f/255.f blue:40.f/255.f alpha:0.9f];
            self.hud.activityIndicatorColor = [UIColor redColor];
            
            [self.hud setFrame:CGRectMake(self.hud.frame.origin.x, self.hud.frame.origin.y - 50, self.hud.frame.size.width, self.hud.frame.size.height)];
            
            [self.hud setLabelText:text];
            [self.hud setLabelColor:[UIColor redColor]];
        }
        self.loaderCount += 1;
        //NSLog(@"Loader++  = %i", self.loaderCount);
        [self.hud show:YES];
    });
}

- (void)hideLoader {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loaderCount -= 1;
        // NSLog(@"Loader--  = %i", self.loaderCount);
        if (self.hud) {
            if (self.loaderCount <= 0) {
                [self.hud hide:YES];
                [self.hud removeFromSuperview];
                self.hud = nil;
            }
        }
    });
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    // NSLog(@"hidddddden= %i",self.loaderCount);
    if (self.loaderCount == 0) {
        [self.hud removeFromSuperview]; //  app crashes at 4.59 MB if you comment this
        self.hud = nil;
    }
}

@end
