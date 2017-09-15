//
//  APIHTTPClient.h
//  Movebox
//
//  Created by  Кирилл Легкодух on 14.09.15.
//  Copyright (c) 2015 Kira Company. All rights reserved.
//
#import "AFHTTPSessionManager.h"

FOUNDATION_EXPORT NSString *const BASE_URL;

@protocol APIHTTPClientDelegate <NSObject>

@optional

- (void)errorHandling:(NSError *)error;
- (void)showErrorMessageInAlertController:(NSString *)message;

@end


@interface APIHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<APIHTTPClientDelegate>delegate;

+ (APIHTTPClient *)sharedAPIHTTPClient;

- (NSDictionary *)handleError:(NSError *)error;

- (NSURLSessionDataTask *)OPTION:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

@end


