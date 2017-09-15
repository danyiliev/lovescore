//
//  AddPersonImages.m
//  LoveScore
//
//  Created by Oleksandr on 12/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "AddPersonImages.h"
#import "NetworkActivityIndicator.h"
#import "APIHTTPClient.h"
#import "CoreDataManager.h"
#import "ImageManager.h"

@interface AddPersonImages ()<APIHTTPClientDelegate>

@property (strong, nonatomic) APIHTTPClient *apiHttpClient;

@end

@implementation AddPersonImages

-(instancetype)init {
    return [self initWithApiHttpClient:[APIHTTPClient sharedAPIHTTPClient]];
}

-(instancetype)initWithApiHttpClient:(APIHTTPClient *)apiHttpClient {
    self = [super init];
    if (self) {
        _apiHttpClient = apiHttpClient;
        _apiHttpClient.delegate = self;
    }
    
    return self;
}

- (RACSignal *)uploadImage:(NSArray *)imagesArray
                    inView:(UIView *)imageView
                 forUUID:(NSString *)uuid
               imagesNames:(NSArray *)imagesName {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL = @"/persons/images";
        
        __block UIActivityIndicatorView *activityIndicator;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicator.center = CGPointMake(imageView.bounds.size.width / 2, imageView.bounds.size.height / 2) ;
            activityIndicator.hidesWhenStopped = YES;
            [imageView addSubview:activityIndicator];
            [activityIndicator startAnimating];
        });
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:uuid, @"uuid", nil];
        
        [self.apiHttpClient POST:tenantURL parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            if (imagesArray && imagesArray.count > 0) {
                
                for (UIImage *image in imagesArray) {
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.6f)
                                                name:@"images[]"
                                            fileName:@"image.jpg"
                                            mimeType:@"image/jpeg"];
                }
            }
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray *identifiersArray = [responseObject objectForKey:@"data"];
            
            [[ImageManager sharedInstance] renameImagesOnUUID:uuid fromNamesArray:imagesName onNewNamesArray:identifiersArray];
                        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator removeFromSuperview];
                    activityIndicator = nil;
                });
            });
            
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator removeFromSuperview];
                    activityIndicator = nil;
                });
            });
        }];
        return nil;
    }];
}

#pragma mark - Delete Image

- (RACSignal *)deletePhotoWithPersonId:(NSString *)personId andImagesArrayId:(NSArray *)array {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL = @"/persons/images";
        
        NSDictionary *dic = @{
                              @"uuid" : personId,
                              @"images" : array
                              };
        
        [self.apiHttpClient DELETE:tenantURL parameters:dic success:^(NSURLSessionDataTask * task, id responseObject) {
            
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            [_apiHttpClient handleError:error];
        }];
        
        return nil;
    }];
}

@end
