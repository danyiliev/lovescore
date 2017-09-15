//
//  BNRImageStore.h
//  Movebox
//
//  Created by Kirill Legkodukh on 1/10/14.
//  Copyright (c) 2015 KindGeek. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation ImageStore

+ (instancetype)sharedStore
{
    static ImageStore *sharedStore;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });

    return sharedStore;
}

// No one should call init
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Secret designated initializer
- (instancetype)initPrivate
{
    self = [super init];

    if (self) {
        NSString *path = [self imagesKeysArchivePath];
        _dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if (!_dictionary) {
            _dictionary = [[NSMutableDictionary alloc] init];
        }

        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }

    return self;
}

- (NSString *)imagesKeysArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"keys.archive"];
}

- (BOOL)saveKeys
{
    NSString *path = [self imagesKeysArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.dictionary toFile:path];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %lu images out of the cache", (unsigned long)[self.dictionary count]);
    
    NSArray *keys = [self.dictionary allKeys];
    for (NSString *key in keys) {
        [self deleteImageForKey:key];
    }
    [self.dictionary removeAllObjects];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:key];

    // Turn image into JPEG data
    NSData *data = UIImageJPEGRepresentation(image, 1);

    // Write it to full path
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    // If possible, get it from the dictionary
    UIImage *result = self.dictionary[key];

    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];

        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];

        // If we found an image on the file system, place it into the cache
        if (result) {
            self.dictionary[key] = result;
        } else {
            //NSLog(@"Error: unable to find %@", imagePath);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
//    DLog(@"DELETE IMAGE FOR KEY : %@", key);
    [self.dictionary removeObjectForKey:key];

    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath
                                               error:NULL];
}

@end
