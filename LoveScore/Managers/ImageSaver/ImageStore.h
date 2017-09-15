//
//  BNRImageStore.h
//  Movebox
//
//  Created by Kirill Legkodukh on 1/10/14.
//  Copyright (c) 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;
- (BOOL)saveKeys;

@end
