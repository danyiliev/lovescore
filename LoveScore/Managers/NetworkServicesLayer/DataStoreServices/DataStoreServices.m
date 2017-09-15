//
//  DataStoreServicesImpl.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/13/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "DataStoreServices.h"
#import "NetworkActivityIndicator.h"
#import "APIHTTPClient.h"
#import "DataStore.h"
#import "CoreDataManager.h"

@interface DataStoreServices () <APIHTTPClientDelegate>

@property (strong, nonatomic) APIHTTPClient *apiHttpClient;

@end

@implementation DataStoreServices


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

- (RACSignal *)getDataStore {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL = @"/data/store?with=states";
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        [self.apiHttpClient GET:tenantURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            DataStore *dataStoreModel = [MTLJSONAdapter modelOfClass:[DataStore class]
                                                  fromJSONDictionary:responseObject
                                                               error:NULL];
            
            NSManagedObjectContext *managedObjectContext = [CoreDataManager instance].managedObjectContext;
            
            //delete
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
            NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
            
            NSError *deleteError = nil;
            [[CoreDataManager instance].persistentStoreCoordinator executeRequest:delete withContext:[CoreDataManager instance].managedObjectContext error:&deleteError];
            
            //insert
            NSError *error;
            [MTLManagedObjectAdapter managedObjectFromModel:dataStoreModel
                                       insertingIntoContext:managedObjectContext
                                                      error:&error];
            
            // save context
            if (![managedObjectContext save:&error]) {
                NSLog(@"managedObjectContext save - %@ %s %@", self.class, __func__, error.description);
            }
            
//            [subscriber sendNext:dataStoreModel];
            [subscriber sendCompleted];
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

- (RACSignal *)getCitiesListWithSearchWord:(NSString *)searchWord inCountry:(NSString *)countryCode {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *googleAppKey = @"AIzaSyBzh0rG-WvR5YyroOXBihTGxoa1NL8Jc0I";
        
        NSString *country = countryCode;
        NSString *region = countryCode;
        NSString *components = [NSString stringWithFormat:@"country:%@",countryCode];
        
        NSString *searchWordProtection = [searchWord stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (searchWordProtection.length != 0) {
            NSString *tenantURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&key=%@&region=%@&country=%@&components=%@", searchWord,googleAppKey, region, country, components];
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
            
            [self.apiHttpClient GET:tenantURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
                [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {

                [_apiHttpClient handleError:error];
                [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
                
                [subscriber sendError:error];
            }];
        }
        return nil;
    }];
    
}

@end
