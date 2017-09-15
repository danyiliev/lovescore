//
//  UIImage+ImageAdditions.h
//  Movebox
//
//  Created by  Кирилл Легкодух on 26.08.15.
//  Copyright (c) 2015 Kira Company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageCacheDownloadCompletionHandler)(UIImage *image);

@interface UIImage (ImageAdditions)

+ (UIImage *)adaptiveImageNamed:(NSString *)name;
+ (NSString *)encodeToBase64String:(UIImage *)image;
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
+ (UIImage *)setThumbnailFromImage:(UIImage *)image newRect:(CGRect)rect;

+ (void)downloadImageAtURL:(NSURL*)url
             withImageView:(UIImageView *)imageView
         completionHandler:(ImageCacheDownloadCompletionHandler)completion;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
