//
//  ImageManager.m
//  LoveScore
//
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ImageManager.h"
#import "UIImage+ImageAdditions.h"
#import "CoreDataManager.h"
#import "PicturesEntity.h"
#import "AddPersonImages.h"

@interface ImageManager ()

@property (nonatomic, strong) AddPersonImages *addPersonImages;

@property (nonatomic) NSNumber *countOfImages;

@end

@implementation ImageManager

static ImageManager *imageManager = nil;

+ (instancetype)sharedInstance {
    
    if (imageManager == nil) {
        imageManager = [[self alloc] initPrivate];
    }
    
    return imageManager;
}

+ (void)resetImageManager {
    
    imageManager = nil;
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
        NSString *path1 = [self imagesAvatarsKeysArchivePath];
        NSString *path2 = [self imagesToDeleteKeysArchivePath];
        NSString *imagesToUploadPath = [self imagesToUploadKeysArchivePath];
        
        self.avatarDictionaries = [[NSKeyedUnarchiver unarchiveObjectWithFile:path1] mutableCopy];
        self.deleteImagesDictionaries = [[NSKeyedUnarchiver unarchiveObjectWithFile:path2] mutableCopy];
        self.imagesToUpload = [[NSKeyedUnarchiver unarchiveObjectWithFile:imagesToUploadPath] mutableCopy];
        
        if (!self.deleteImagesDictionaries) {
            self.deleteImagesDictionaries = [NSMutableDictionary new];
        }
        
        if (!self.imagesToUpload) {
            self.imagesToUpload = [NSMutableDictionary new];
        }
        
        // If the array hadn't been saved previously, create a new empty one
        if (!self.avatarDictionaries || self.avatarDictionaries.count == 0) {
            self.avatarDictionaries = [NSMutableDictionary new];
            
            NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Pictures"];
            
            NSError *lError = nil;
            NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
            
            if (lReturn && lReturn > 0) {
                for (PicturesEntity *picturesEntity in lReturn) {
                    
                    NSArray *arr = [self getImagesArrayWithUUID:picturesEntity.uuid];
                    
                    if (arr && arr.count > 0) {
                        [self.avatarDictionaries setObject:arr[0] forKey:picturesEntity.uuid];
                    }
                }
            }
        }
    }
    
    return self;
}

#pragma mark - archive methods

- (NSString *)imagesAvatarsKeysArchivePath {
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    NSString *documentsResourcesPath = [documentDirectory  stringByAppendingPathComponent:@"MyAppCache"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentsResourcesPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsResourcesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [documentsResourcesPath stringByAppendingPathComponent:@"keys.avatars"];
}

- (NSString *)imagesToDeleteKeysArchivePath {
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    NSString *documentsResourcesPath = [documentDirectory  stringByAppendingPathComponent:@"MyAppCache"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentsResourcesPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsResourcesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [documentsResourcesPath stringByAppendingPathComponent:@"keys.deletion"];
}

- (NSString *)imagesToUploadKeysArchivePath {
    
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    NSString *documentsResourcesPath = [documentDirectory  stringByAppendingPathComponent:@"MyAppCache"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentsResourcesPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsResourcesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [documentsResourcesPath stringByAppendingPathComponent:@"keys.upload"];
}

- (BOOL)saveKeys {
    
    NSString *path1 = [self imagesAvatarsKeysArchivePath];
    
    NSString *path2 = [self imagesToDeleteKeysArchivePath];
    
    NSString *pathToUplaod = [self imagesToUploadKeysArchivePath];
    
    BOOL result = [NSKeyedArchiver archiveRootObject:self.avatarDictionaries toFile:pathToUplaod];
    result = result && [NSKeyedArchiver archiveRootObject:self.avatarDictionaries toFile:path1];
    result = result && [NSKeyedArchiver archiveRootObject:self.avatarDictionaries toFile:path2];
    
    return result;
}

- (void)clearCache:(NSNotification *)note {
    
    [self.avatarDictionaries removeAllObjects];
    [self.deleteImagesDictionaries removeAllObjects];
    [self.imagesToUpload removeAllObjects];
}

#pragma mark - Public methods

- (void)setAvatarPath:(NSString *)avatarPath onKey:(NSString *)key {
    
    NSLog(@"Saving");
    
    UIImage *image = [UIImage imageWithContentsOfFile:avatarPath];
    
    if (image != nil) {
        
        CGFloat newWidth;
        CGFloat newHeight;
        
        if (image.size.width > 100 || image.size.height > 100) {
            if (image.size.width > image.size.height) {
                newWidth = 100;
                newHeight = image.size.height / (image.size.width / newWidth);
            } else {
                newHeight = 100;
                newWidth = image.size.width / (image.size.height / newHeight);
            }
            
            image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(newWidth, newHeight)];
        }
    }
    
    NSString *name = [avatarPath lastPathComponent];
    name = [name stringByReplacingOccurrencesOfString:@".png" withString:@""];
    
    name = [@"star" stringByAppendingString:name];
    
    
    NSString *path = @"avatar";
    
    [self.avatarDictionaries setObject:path forKey:key];
    
     path = [self saveImage:image withName:name andWithUUID:key];
    
    [self.avatarDictionaries setObject:path forKey:key];
}

- (NSString *)saveImage:(UIImage *)image withUUID:(NSString *)uuid {
    
    if (image != nil) {
        
        [self calculateCountOfImagesWithUUID:uuid];
        self.countOfImages = [NSNumber numberWithInt:[self.countOfImages intValue] + 1];
        
        return [self saveImage:image withName:[self.countOfImages stringValue] andWithUUID:uuid];
    }
    return nil;
}

- (NSString *)saveImage:(UIImage*)image withName:(NSString *)name andWithUUID:(NSString *)uuid {
    
    if (image != nil) {
        
        CGFloat newWidth;
        CGFloat newHeight;
        
        if (image.size.width > 1000 || image.size.height > 1000) {
            if (image.size.width > image.size.height) {
                newWidth = 1000;
                newHeight = image.size.height / (image.size.width / newWidth);
            } else {
                newHeight = 1000;
                newWidth = image.size.width / (image.size.height / newHeight);
            }
            
            image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(newWidth, newHeight)];
        }
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:uuid];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    }
    path = [documentsDirectory stringByAppendingPathComponent:uuid];
    
    NSString *imageName = nil;
    
    imageName = [name stringByAppendingString:@".png"];
    path = [path stringByAppendingPathComponent:imageName];
    
    if (![self.avatarDictionaries objectForKey:uuid]) {
//    if (image && ![self.avatarDictionaries objectForKey:uuid]) {
//        [self setAvatarPath:path onKey:uuid];
        [self.avatarDictionaries setObject:path forKey:uuid];
    }
    
    if (image) {
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
    
    return path;
}

- (void)renameImagesOnUUID:(NSString *)uuid fromNamesArray:(NSArray *)oldNames onNewNamesArray:(NSArray *)newNamesArray {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
    
    NSString *path = [documentsDirectory stringByAppendingString:uuid];
    path = [path stringByAppendingString:@"/"];
    
    
    for (int i = 0; i < oldNames.count; i++) {
        NSError * err = NULL;
        NSFileManager * fm = [[NSFileManager alloc] init];
        
        BOOL result;
        NSString *fileName;
        
        fileName = [newNamesArray[i] stringByAppendingString:@".png"];
        
        
        result = [fm moveItemAtPath:[path stringByAppendingString:oldNames[i]] toPath:[path stringByAppendingString:fileName] error:&err];
        
        if(!result) {
            NSLog(@"Error: %@", err);
        }
    }
}

- (void)calculateCountOfImagesWithUUID:(NSString *)uuid {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:uuid];
    
    NSError *error;
    NSArray *filelist= [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    if (error) {
        NSLog(@"Error in gallery - %@", error);
    }
    
    self.countOfImages = [NSNumber numberWithInteger:[filelist count]];
}

- (NSArray *)getImagesArrayWithUUID:(NSString *)uuid {
    [self calculateCountOfImagesWithUUID:uuid];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:uuid];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    //    NSLog(@"directoryContent - %@", directoryContent);
    
    NSMutableArray *imagePathArray = [NSMutableArray new];
    
    for (NSInteger i = 0; i < [self.countOfImages integerValue]; i++) {
        NSString *imagePath = [path stringByAppendingPathComponent:directoryContent[i]];
        
        if ([imagePath containsString:@".png"]) {
            [imagePathArray addObject:imagePath];
        }
    }
    
    NSString *avatarPath = [self.avatarDictionaries objectForKey:uuid];
    
    for (NSInteger i = 1; i < imagePathArray.count; i++) {
        if ([avatarPath isEqualToString:imagePathArray[i]]) {
            [imagePathArray replaceObjectAtIndex:i withObject:imagePathArray[0]];

            [imagePathArray replaceObjectAtIndex:0 withObject:avatarPath];
        }
    }
    
    return imagePathArray;
}


- (BOOL)existFileWithName:(NSString *)name andUUID:(NSString *)uuid {
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
    
    NSString *file = [documentsDirectory stringByAppendingPathComponent:uuid];
    
    file = [file stringByAppendingPathComponent:[name stringByAppendingString:@".png"]];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:file];
    
    return fileExists;
}


#pragma mark - User avatar methods

- (void)saveUserAvatar:(UIImage *)image {
    if (image != nil) {
        
        CGFloat newWidth;
        CGFloat newHeight;
        
        if (image.size.width > image.size.height) {
            newWidth = 1000;
            newHeight = image.size.height / (image.size.width / newWidth);
        } else {
            newHeight = 1000;
            newWidth = image.size.width / (image.size.height / newHeight);
        }
        
        image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(newWidth, newHeight)];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
        
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error];
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"0"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        }
        
        path = [documentsDirectory stringByAppendingPathComponent:@"0"];
        
        NSString *imageName = [path stringByAppendingPathComponent:@"avatar.png"];
        
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:imageName atomically:YES];
    }
}

- (UIImage *)getUserAvatarImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"0"];
    
    NSString *imageName = [path stringByAppendingPathComponent:@"avatar.png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imageName];
    
    return image;
}

- (void)deleteUserAvatar {
    [self deleteAllImagesWithUUID:@"0"];
}

#pragma mark - Avatar methods

- (UIImage *)getAvatarImageForUUID:(NSString *)uuid {
    
    UIImage *image = nil;
    
    if ([self.avatarDictionaries objectForKey:uuid] && [[self.avatarDictionaries objectForKey:uuid] length]) {
        image = [UIImage imageWithContentsOfFile:[self.avatarDictionaries objectForKey:uuid]];
        //        image = [UIImage imageNamed:[self.avatarDictionaries objectForKey:uuid]]
    }
    
    return image;
}

- (void)makeImageAvatarOnPath:(NSString *)path withUUID:(NSString *)uuid {
//    [self setAvatarPath:path onKey:uuid];

    [self.avatarDictionaries setObject:path forKey:uuid];
}

#pragma mark - Delete methods

- (void)deleteAllImages {
    
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
    
    [self deleteImageWithPath:documentsDirectory];
}

- (void)deleteAllImagesWithUUID:(NSString *)uuid {
    
    NSArray *pathArray = [self getImagesArrayWithUUID:uuid];
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSString *path in pathArray) {
        NSString *ident = [path lastPathComponent];
        
        [ident stringByReplacingOccurrencesOfString:@".png" withString:@""];
        [ident stringByReplacingOccurrencesOfString:@"star" withString:@""];
        [array addObject:ident];
    }
    
    if ([[SyncManager sharedInstance] connected]) {
        AddPersonImages *addPersonImages = [AddPersonImages new];
        [[addPersonImages deletePhotoWithPersonId:uuid andImagesArrayId:array] subscribeCompleted:^(void) {
            
            NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
            documentsDirectory = [documentsDirectory stringByAppendingPathComponent:uuid];
            [self deleteImageWithPath:documentsDirectory];
            
        }];
    } else {
        //TODO: do something if there is no internet connection
        NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:uuid];
        [self deleteImageWithPath:documentsDirectory];
    }
}

- (void)deleteImageWithName:(NSString *)imageName andWithUUID:(NSString *)uuid {
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"gallery"];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:uuid];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    
    [self deleteImageWithPath:documentsDirectory];
}

- (void)deleteImageWithPath:(NSString *)documentsDirectory {
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    
    BOOL removeSuccess = [fileMgr removeItemAtPath:documentsDirectory error:&error];
    if (!removeSuccess) {
        NSLog(@"Something wrong with image removing");
    }
}

@end