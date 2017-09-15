//
//  FriendsServicesImpl.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/18/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "FriendsServices.h"
#import "NetworkActivityIndicator.h"
#import "APIHTTPClient.h"
#import "FriendsEntity.h"
#import "CoreDataManager.h"

@interface FriendsServices () <APIHTTPClientDelegate>

@property (strong, nonatomic) APIHTTPClient *apiHttpClient;

@end

@implementation FriendsServices

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

#pragma mark - get methods for friends

- (RACSignal *)getFriendsWithLimit:(NSString *)limit andWithPage:(NSString *)page {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL =[NSString stringWithFormat:@"/friends?limit=%@&page=%@",limit,page];
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        [self.apiHttpClient GET:tenantURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

            NSDictionary *dictionaryResponseObject = responseObject;
            
            if (responseObject && dictionaryResponseObject.count > 0) {
                
                NSArray *friendsArray = [responseObject objectForKey:@"data"];
                
                [friendsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger isx, BOOL *stop) {
                    
                    NSDictionary *dictionary = obj;
                    
                    FriendsEntity *friend = (FriendsEntity *)[[CoreDataManager instance] insertNewManagedObject:@"Friends"];
                    friend.username = [dictionary objectForKey:@"username"];
                    friend.displayName = [dictionary objectForKey:@"display_name"];
                    friend.state = @"friend";
                    
                    [[CoreDataManager instance] saveContext];
                }];
            }
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}


- (RACSignal *)getIncomingFriendsWithLimit:(NSString *)limit andWithPage:(NSString *)page savingToDatabase:(BOOL) saveToDatabase {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL =[NSString stringWithFormat:@"/friends/incoming?limit=%@&page=%@",limit,page];
        if (saveToDatabase) {
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        }
        
        [self.apiHttpClient GET:tenantURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if (saveToDatabase) {
            NSDictionary *dictionaryResponseObject = responseObject;
            
            if (responseObject && dictionaryResponseObject.count > 0) {
                
                NSArray *friendsArray = [responseObject objectForKey:@"data"];
                
                [friendsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger isx, BOOL *stop) {
                    
                    NSDictionary *dictionary = obj;
                    
                    FriendsEntity *friend = (FriendsEntity *)[[CoreDataManager instance] insertNewManagedObject:@"Friends"];
                    friend.username = [dictionary objectForKey:@"username"];
                    friend.displayName = [dictionary objectForKey:@"display_name"];
                    friend.state = @"incoming";
                    
                    [[CoreDataManager instance] saveContext];
                }];
            }
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            }
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

- (RACSignal *)getOutgoingFriendsWithLimit:(NSString *)limit andWithPage:(NSString *)page {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL =[NSString stringWithFormat:@"/friends/outgoing?limit=%@&page=%@",limit,page];
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        [self.apiHttpClient GET:tenantURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSDictionary *dictionaryResponseObject = responseObject;
            
            if (responseObject && dictionaryResponseObject.count > 0) {
                
                NSArray *friendsArray = [responseObject objectForKey:@"data"];
                
                [friendsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger isx, BOOL *stop) {
                    
                    NSDictionary *dictionary = obj;
                    
                    FriendsEntity *friend = (FriendsEntity *)[[CoreDataManager instance] insertNewManagedObject:@"Friends"];
                    friend.username = [dictionary objectForKey:@"username"];
                    friend.displayName = [dictionary objectForKey:@"display_name"];
                    friend.state = @"outgoing";
                    
                    [[CoreDataManager instance] saveContext];
                }];
            }
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}


#pragma mark - search friend method
- (RACSignal *)searchUsers:(NSString *)username {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary *params = @{
                                 @"username" : username
                                 };
        
        NSString *tenantURL = @"/friends";
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        [self.apiHttpClient OPTION:tenantURL parameters:params success:^(id responseObject) {
                        
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];            
        }];
        return nil;
    }];
}

#pragma mark - friends requests (create, accept, cancel, reject, delete)

- (RACSignal *)createFriendsRequest:(NSString *)username {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        NSDictionary *params = @{
                                 @"username" : username
                                 };
        
        NSString *tenantURL = [NSString stringWithFormat:@"/friends?username=%@&action=create",username];
        
        [self.apiHttpClient PUT:tenantURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];

            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

- (RACSignal *)acceptFriendsRequest:(NSString *)username {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        NSDictionary *params = @{
                                 @"username" : username
                                 };
        
        NSString *tenantURL = [NSString stringWithFormat:@"/friends?username=%@&action=accept",username];
        
        [self.apiHttpClient PUT:tenantURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            //            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

- (RACSignal *)cancelFriendsRequest:(NSString *)username {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        NSDictionary *params = @{
                                 @"username" : username
                                 };
        
        NSString *tenantURL = [NSString stringWithFormat:@"/friends?username=%@&action=cancel",username];
        
        [self.apiHttpClient DELETE:tenantURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

- (RACSignal *)rejectFriendsRequest:(NSString *)username {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        NSDictionary *params = @{
                                 @"username" : username
                                 };
        
        NSString *tenantURL = [NSString stringWithFormat:@"/friends?username=%@&action=reject",username];
        
        [self.apiHttpClient DELETE:tenantURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

- (RACSignal *)deleteFriendsRequest:(NSString *)username {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        NSDictionary *params = @{
                                 @"username" : username
                                 };
        
        NSString *tenantURL = [NSString stringWithFormat:@"/friends?username=%@&action=delete",username];
        
        [self.apiHttpClient DELETE:tenantURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

@end
