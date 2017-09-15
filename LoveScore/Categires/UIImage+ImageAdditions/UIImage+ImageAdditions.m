//
//  UIImage+ImageAdditions.m
//  Movebox
//
//  Created by  Кирилл Легкодух on 26.08.15.
//  Copyright (c) 2015 Kira Company. All rights reserved.
//

#import "UIImage+ImageAdditions.h"

@implementation UIImage (ImageAdditions)

+ (NSString *)resolveAdaptiveImageName:(NSString *)nameStem {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height > 568.0f) {
        // Oversize @2x will be used for iPhone 6, @3x for iPhone 6+
        if (height > 667.0f) {
            return [nameStem stringByAppendingString:@"-oversize@3x"];
        } else {
            return [nameStem stringByAppendingString:@"-oversize"];
        }
    };
    return nameStem;
}

+ (UIImage *)adaptiveImageNamed:(NSString *)name {
    return [self imageNamed:[self resolveAdaptiveImageName:name]];
}

+ (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+ (UIImage *)setThumbnailFromImage:(UIImage *)image newRect:(CGRect)rect
{
    CGSize origImageSize = image.size;
    
    // The rectangle of the thumbnail
    CGRect newRect = rect;
    
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:0.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    
    [image drawInRect:projectRect];
    
    // Get the image from the image context; keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Cleanup image context resources; we're done
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (void)downloadImageAtURL:(NSURL*)url withImageView:(UIImageView *)imageView completionHandler:(ImageCacheDownloadCompletionHandler)completion {
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    dispatch_async(dispatch_get_main_queue(), ^{
        activityIndicator.center = CGPointMake(imageView.bounds.size.width / 2, imageView.bounds.size.height / 2) ;
        activityIndicator.hidesWhenStopped = YES;
        [imageView addSubview:activityIndicator];
        [activityIndicator startAnimating];
    });
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIImage *cachedImage;
    NSData *imageData = [defaults objectForKey:@"imageData"];
    if (imageData) {
        cachedImage = [UIImage imageWithData:imageData];
    }
    if (cachedImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(cachedImage);
                [activityIndicator removeFromSuperview];
                activityIndicator = nil;
            });
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            if (data != nil) {
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image);
                    [activityIndicator removeFromSuperview];
                    activityIndicator = nil;
                });
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator removeFromSuperview];
                    activityIndicator = nil;
                    NSLog(@"!!!!!!!!!!! Can't download image !!!!!!!!!!%@", url);
                });
                
            }
            
        });
    }
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
