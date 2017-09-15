//
//  SyncManager.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/26/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncManager : NSObject

@property (nonatomic) BOOL checkForDataStore;
@property (nonatomic) BOOL checkForPersonsUploading;
@property (nonatomic) BOOL checkForImagesUploading;
@property (nonatomic) BOOL checkForAvatarUploading;

@property (nonatomic, strong) NSMutableDictionary *imagesToDelete;
@property (nonatomic, strong) NSMutableDictionary *imagesToUpload;


- (BOOL)connected;

- (void)downloadPersonsInfo;

+ (instancetype)sharedInstance;

- (void)resetManager;

- (void)logOut;

@end
