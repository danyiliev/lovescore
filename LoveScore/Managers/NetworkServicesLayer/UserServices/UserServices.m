//
//  UserServicesImplementation.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/5/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "UserServices.h"
#import "MBProgressHUD.h"
#import "NetworkActivityIndicator.h"
#import "User.h"
#import "CoreDataManager.h"

#import "ImageManager.h"
#import "SideMenuModel.h"

@interface UserServices () <APIHTTPClientDelegate>

@property (strong, nonatomic) APIHTTPClient *apiHttpClient;

@end

@implementation UserServices

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

- (RACSignal *)loginWithUsername:(NSString *)username password:(NSString *)password {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoaderWithText:@"Login..."];
        
        NSDictionary *params = @{
                                 @"username" : username,
                                 @"password" : password
                                 };
        
        NSString *tenantURL = [NSString stringWithFormat:@"/login"];
        [self.apiHttpClient POST:tenantURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSDictionary *tokens = (NSDictionary *)responseObject;
            NSString *token = [[tokens objectForKey:@"data"] objectForKey:@"token"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:token forKey:@"accessToken"];
            
            [_apiHttpClient.requestSerializer setValue:token forHTTPHeaderField:@"X-LoveScore-Token"];
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            
            [subscriber sendNext:token];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            [self showErrorMessageInAlertController:@"The username or password you have entered is invalid."];
            
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
}

- (RACSignal *)registrationWithUsername:(NSString *)username
                               password:(NSString *)password
                                  email:(NSString *)email
                                country:(NSString *)country {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)  {
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        NSString *tenantUrlString = @"/register";
        
        NSDictionary *params =  @{
                                  @"username" : username,
                                  @"password" : password,
                                  @"email" : email,
                                  @"country" : country
                                  };
        
        [self.apiHttpClient POST:tenantUrlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];

            [subscriber sendNext:[_apiHttpClient handleError:error]];
            
            [subscriber sendCompleted];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        
        return nil;
    }];
}

- (RACSignal *)retrieveUserDetails {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoaderWithText:@"Downloading user info"];
        
        NSString *tenantUrlString = @"/user";
        [self.apiHttpClient GET:tenantUrlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            NSManagedObjectContext *managedObjectContext = [CoreDataManager instance].managedObjectContext;
            
            NSError *error;
            
            User *user = [MTLJSONAdapter modelOfClass:[User class]
                                   fromJSONDictionary:responseObject
                                                error:&error];
            
             [((AppDelegate *)[[UIApplication sharedApplication] delegate]).oneSignal sendTags:@{@"language" : @"en", @"username" : user.username}];
            
            [MTLManagedObjectAdapter managedObjectFromModel:user
                                       insertingIntoContext:managedObjectContext
                                                      error:&error];
            
            if (![managedObjectContext save:&error]) {
                NSLog(@"getPersonsWithLimit request, managedObjectContext save - %@ %s %@", self.class, __func__, error.description);
            }
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];

            if (user.avatarUrl && user.avatarUrl.length > 0) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    UIImage *avatarImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatarUrl]]];
                    
                    [[ImageManager sharedInstance] saveUserAvatar:avatarImage];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [[SideMenuModel sharedInstance] setAvatar:avatarImage];
                    });
                });
            }
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

- (RACSignal *)updateUserDetailsWithField:(NSString *)field value:(id)value {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *tenantUrlString = @"/user";
        NSDictionary *params = @{
                                 @"field" : field,
                                 @"value" : value
                                 };
        [self.apiHttpClient PATCH:tenantUrlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.apiHttpClient handleError:error];
            [subscriber sendError:error];
            
        }];
        return nil;
    }];
}

- (RACSignal *)uploadNotificationSettings:(NSDictionary *)params {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *tenantUrlString = @"/user/notifications";
        [self.apiHttpClient PATCH:tenantUrlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [subscriber sendNext:responseObject];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)removeUserImage {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *tenantUrlString = @"/user/avatar";
        [self.apiHttpClient DELETE:tenantUrlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.apiHttpClient handleError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)getNewPasswordForUserWithUsername:(NSString *)username {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *tenantUrlString = [NSString stringWithFormat:@"/reset?username=%@",username];
        [self.apiHttpClient GET:tenantUrlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.apiHttpClient handleError:error];
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
}

- (RACSignal *)wipeUserAcount {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *tenantUrlString = @"/user";
        
        [self.apiHttpClient DELETE:tenantUrlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary *token = [responseObject objectForKey:@"data"];
            
            [[self wipeWithToken:[token objectForKey:@"token"]] subscribeCompleted:^(void) {
                [subscriber sendCompleted];
            }];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.apiHttpClient handleError:error];
            
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)wipeWithToken:(NSString *)token {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantUrlString = [NSString stringWithFormat:@"/user?token=%@",token];
        
        [self.apiHttpClient DELETE:tenantUrlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.apiHttpClient handleError:error];
            
            [subscriber sendError:error];
        }];
        return nil;
    }];
}



#pragma mark - APIHTTPClientDelegate

- (void)errorHandling:(NSError *)error {
    
    NSLog(@"error - %@", error);
}

- (void)showErrorMessageInAlertController:(NSString *)message {
    if ([self.delegate respondsToSelector:@selector(showErrorMessage:)]) {
        [self.delegate performSelector:@selector(showErrorMessage:) withObject:message];
    }
}

#pragma mark - Avatar

- (RACSignal *)uploadAvatarImage:(UIImage *)image
                          inView:(UIView *)imageView {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL = @"/user/avatar";
        
        __block UIActivityIndicatorView *activityIndicator;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicator.center = CGPointMake(imageView.bounds.size.width / 2, imageView.bounds.size.height / 2) ;
            activityIndicator.hidesWhenStopped = YES;
            [imageView addSubview:activityIndicator];
            [activityIndicator startAnimating];
        });
        
        [self.apiHttpClient POST:tenantURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (image) {
                                
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.6f)
                                            name:@"avatar"
                                        fileName:@"image.jpg"
                                        mimeType:@"image/jpeg"];
                
            }
        } success:^(NSURLSessionDataTask *task, id responseObject) {
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
            
            [subscriber sendError:error];
        }];
        return nil;
    }];
    
}

@end
