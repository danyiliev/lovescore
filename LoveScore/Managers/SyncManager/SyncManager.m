//
//  SyncManager.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/26/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SyncManager.h"

#import "DataStoreServices.h"
#import "AddGirlsServices.h"
#import "AddPersonImages.h"
#import "UserServices.h"
#import "ImageManager.h"
#import "CoreDataManager.h"
#import "SideMenuModel.h"
#import "PicturesEntity.h"
#import "DownloadOperation.h"

NSString *const  dataStoreUpload = @"dataStoreUpload";
NSString *const  personUpload = @"personUpload";
NSString *const  imagesUpload = @"imagesUpload";
NSString *const  avatarUpload = @"avatarUpload";

@interface SyncManager ()

@property (nonatomic, strong) AddGirlsServices *addGirlsServices;
@property (nonatomic, strong) NSString *curPage;

@end

@implementation SyncManager

#pragma mark - Init methods
+ (instancetype)sharedInstance {
    static SyncManager *syncManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        syncManager = [[SyncManager alloc] initPrivate];;
    });
    return syncManager;
}

// No one should call init
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Secret designated initializer
- (instancetype)initPrivate {
    self = [super init];
    
    if (self) {
        
        // Start Monitoring
        self.checkForDataStore = NO;
        self.checkForPersonsUploading = NO;
        self.checkForAvatarUploading = NO;
        self.checkForImagesUploading = NO;
        
        
        self.imagesToDelete = [NSMutableDictionary new];
        self.imagesToUpload = [NSMutableDictionary new];
        self.curPage = @"1";
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityDidChange:)
                                                     name:AFNetworkingReachabilityDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - Public methods

- (void)setCheckForAvatarUploading:(BOOL)checkForAvatarUploading {
    _checkForAvatarUploading = checkForAvatarUploading;
    [[NSUserDefaults standardUserDefaults] setBool:checkForAvatarUploading forKey:avatarUpload];
}

- (void)setCheckForDataStore:(BOOL)checkForDataStore {
    _checkForDataStore = checkForDataStore;
    [[NSUserDefaults standardUserDefaults] setBool:checkForDataStore forKey:dataStoreUpload];
}

- (void)setCheckForImagesUploading:(BOOL)checkForImagesUploading {
    _checkForImagesUploading = checkForImagesUploading;
    [[NSUserDefaults standardUserDefaults] setBool:checkForImagesUploading forKey:imagesUpload];
}

- (void)setCheckForPersonsUploading:(BOOL)checkForPersonsUploading {
    _checkForPersonsUploading = checkForPersonsUploading;
    [[NSUserDefaults standardUserDefaults] setBool:checkForPersonsUploading forKey:personUpload];
}

- (void)downloadPersonsInfo {
    
    if (!self.addGirlsServices) {
        self.addGirlsServices = [AddGirlsServices new];
    }
    
    [[self.addGirlsServices getPersonsWithLimit:@"25" andPage:self.curPage] subscribeNext:^(id x) {
        
        NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Pictures"];
        
        NSError *lError = nil;
        NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
        
        if (lReturn && lReturn > 0) {
            
            NSOperationQueue *downloadQueue = [[NSOperationQueue alloc] init];
            __block  int i = 0;
            for (PicturesEntity *picturesEntity in lReturn) {
                NSString *stringToDownload;
                NSString *name;

                for (NSDictionary *pic in picturesEntity.pictures) {
                    stringToDownload = [pic objectForKey:@"url"];
                    name = [pic objectForKey:@"ident"];
                    
                    NSURL *url = [NSURL URLWithString:stringToDownload];
                    
                    NSString *filePath = [[ImageManager sharedInstance] saveImage:nil withName:name andWithUUID:picturesEntity.uuid];
                    
                    DownloadOperation *downloadOperation = [[DownloadOperation alloc] initWithURL:url path:filePath];
                    downloadOperation.downloadCompletionBlock = ^(DownloadOperation *operation, BOOL success, NSError *error) {
                        i++;
                        if (i < 7 ) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ComplateDownloadPhotos" object:nil];
                        }


//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//                            if(success) {
//                                if (![[ImageManager sharedInstance].avatarDictionaries objectForKey:picturesEntity.uuid]) {
//                                    
//                                    [[ImageManager sharedInstance] setAvatarPath:filePath onKey:picturesEntity.uuid];
//                                }
//                            }
//                            
//                            if (error) {
//                                NSLog(@"download of %@ failed: %@", operation.url, error);
//                            }
//                            
//                        });
                    };
                    [downloadQueue addOperation:downloadOperation];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSDictionary* userInfo = @{
                                       @"imageWasDownloaded": [NSNumber numberWithBool:YES]
                                       };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:changesWithGirlsNotification object:self userInfo:userInfo];
        });
        
        NSDictionary *dict = x;
        
        NSNumber *currentPage = [dict objectForKey:@"current_page"];
        currentPage = [NSNumber numberWithInt:([currentPage intValue] + 1)];
        NSNumber *totalPages = [dict objectForKey:@"total_pages"];
        
        self.curPage = [currentPage stringValue];
        
        if ([currentPage integerValue] <= [totalPages integerValue]) {
            [self downloadPersonsInfo];
        }
    }];
}

- (void)resetManager {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:avatarUpload];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:dataStoreUpload];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:imagesUpload];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:personUpload];
    
    self.checkForDataStore = NO;
    self.checkForPersonsUploading = NO;
    self.checkForAvatarUploading = NO;
    self.checkForImagesUploading = NO;
    
    
    self.imagesToDelete = [NSMutableDictionary new];
    self.imagesToUpload = [NSMutableDictionary new];
    self.curPage = @"1";
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityDidChange:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
}

#pragma mark - Private methods

- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    NSLog(@"Rechability Changed: %@", notification.userInfo);
    
    BOOL reachable;
    NSInteger status = [[notification.userInfo objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    
    switch(status) {
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"No Internet Connection");
            reachable = NO;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"WIFI");
            reachable = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"3G");
            reachable = YES;
            break;
        default:
            NSLog(@"Unkown network status");
            reachable = NO;
            break;
    }
    
    if (reachable) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:dataStoreUpload]) {
            [self dataStoreRequest];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:personUpload]) {
            [self personsUploadingRequest];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:imagesUpload]) {
            [self imagesUploadingRequest];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:avatarUpload]) {
            [self avatarUploading];
        }
    }
}

- (void)dataStoreRequest {
    
    DataStoreServices *dataStoreImpl = [DataStoreServices new];
    [[dataStoreImpl getDataStore] subscribeCompleted:^(void) {
        self.checkForDataStore = NO;
    }];
}

- (void)personsUploadingRequest {
    AddGirlsServices *girlsServices = [AddGirlsServices new];
    
    [[girlsServices uploadPersons] subscribeCompleted:^(void) {
        NSArray *uuidsArray = [[CoreDataManager instance] cleanDeletedPerson];
        
        for (NSString *uuid in uuidsArray) {
            [[ImageManager sharedInstance] deleteAllImagesWithUUID:uuid];
        }
        self.checkForPersonsUploading = NO;
    }];
}

- (void)imagesUploadingRequest {
    AddPersonImages *addPersonImages = [AddPersonImages new];
    
    
    NSDictionary *dictionary =  [ImageManager sharedInstance].deleteImagesDictionaries;
    for (NSString *key in [dictionary allKeys]) {
        
        [[addPersonImages deletePhotoWithPersonId:key andImagesArrayId:@[[dictionary objectForKey:key]]] subscribeError:^(NSError *error) {
            
        }   completed:^(void) {
            [[ImageManager sharedInstance].deleteImagesDictionaries removeObjectForKey:key];
        }];
    }
    
    NSDictionary *uploadDictionary =  [ImageManager sharedInstance].imagesToUpload;
    
    for (NSString *key in [uploadDictionary allKeys]) {
        NSArray *array = [uploadDictionary objectForKey:key];
        NSMutableArray *arrayWithImages = [NSMutableArray new];
        for (NSString *path in array) {
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            if (image) {
                [arrayWithImages addObject:image];
            }
        }
        
        [[addPersonImages uploadImage:[arrayWithImages copy] inView:nil forUUID:key imagesNames:array] subscribeCompleted:^{
            [[ImageManager sharedInstance].imagesToUpload removeObjectForKey:key];
        }];
        
    }
    
}

- (void)avatarUploading {
    
    UserServices *userServices  = [UserServices new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSArray *array = [[ImageManager sharedInstance] getImagesArrayWithUUID:@"0"];
        
        UIImage *avatarImage = array[0];
        [[userServices uploadAvatarImage:avatarImage inView:nil]
         subscribeError:^(NSError *error) {
             
         }
         completed:^(void) {
             self.checkForAvatarUploading = NO;
         }];
    });
}

- (void)logOut {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[ImageManager sharedInstance] deleteAllImages];
        [[CoreDataManager instance] cleanCoreData];
        [self resetManager];
        
        [ImageManager resetImageManager];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SideMenuModel resetSharedInstance];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AllowSideMenu];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UINavigationController *initViewController = [storyboard instantiateInitialViewController];
            
            AppDelegate *appDelegate = (AppDelegate *) 	[[UIApplication sharedApplication] delegate];
            [appDelegate deleteOneSignalTags];
            
//            appDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            appDelegate.window.rootViewController = initViewController;
            [appDelegate.window makeKeyAndVisible];
        });
    });
}

@end
