//
//  ImageManager.h
//  LoveScore
//
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^completion)(BOOL);

@interface ImageManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *avatarDictionaries;
@property (nonatomic, strong) NSMutableDictionary *deleteImagesDictionaries;

@property (nonatomic, strong) NSMutableDictionary *imagesToUpload;

+ (instancetype)sharedInstance;
+ (void)resetImageManager;

// arcviving methods
- (BOOL)saveKeys;

- (NSString *)saveImage:(UIImage*)image withUUID:(NSString *)uuid;
- (NSString *)saveImage:(UIImage*)image withName:(NSString *)name andWithUUID:(NSString *)uuid;

- (void)setAvatarPath:(NSString *)avatarPath onKey:(NSString *)key;

- (void)renameImagesOnUUID:(NSString *)uuid fromNamesArray:(NSArray *)oldNames onNewNamesArray:(NSArray *)newNamesArray;

- (void)calculateCountOfImagesWithUUID:(NSString *)uuid;
- (NSArray *)getImagesArrayWithUUID:(NSString *)uuid;

// user avatar methods
- (void)saveUserAvatar:(UIImage *)image;
- (UIImage *)getUserAvatarImage;
- (void)deleteUserAvatar;

// avatar methods
- (UIImage *)getAvatarImageForUUID:(NSString *)uuid;

- (void)makeImageAvatarOnPath:(NSString *)path withUUID:(NSString *)uuid;

// delete methods
- (void)deleteAllImages;
- (void)deleteAllImagesWithUUID:(NSString *)uuid;
- (void)deleteImageWithName:(NSString *)imageName andWithUUID:(NSString *)uuid;
- (void)deleteImageWithPath:(NSString *)documentsDirectory;
@end
