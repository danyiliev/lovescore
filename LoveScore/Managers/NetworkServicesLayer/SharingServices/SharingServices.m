//
//  SharingServicesImpl.m
//  LoveScore
//
//  Created by Oleksandr on 12/17/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "SharingServices.h"
#import "MBProgressHUD.h"
#import "NetworkActivityIndicator.h"
#import "APIHTTPClient.h"
#import "RetrieveInbox.h"
#import "CoreDataManager.h"
#import "CardModel.h"
#import "Person.h"
@interface SharingServices () <APIHTTPClientDelegate>

@property (strong, nonatomic) APIHTTPClient *apiHttpClient;

@end

@implementation SharingServices

#pragma mark - int ans system methods
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

#pragma mark - share method

// share card with some users
- (RACSignal *)shareCardWithModel:(ShareCard *)shareCard {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL = [NSString stringWithFormat:@"/share"];
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        NSDictionary *parametersJson = [MTLJSONAdapter JSONDictionaryFromModel:shareCard];
        
        
        [self.apiHttpClient PUT:tenantURL parameters:parametersJson success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

#pragma mark - get methods

- (RACSignal *)getRetrieveInboxWithLimit:(NSInteger)limit andWithPage:(NSInteger)page savingToDatabase:(BOOL)saveToDatabase {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL = [NSString stringWithFormat:@"/share?limit=%li&page=%li", (long)limit, (long)page];
        if(saveToDatabase){
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        }
        
        [self.apiHttpClient GET:tenantURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if(saveToDatabase){
                NSDictionary *dictionary = [responseObject objectForKey:@"data"];
                
                NSManagedObjectContext *managedObjectContext = [CoreDataManager instance].managedObjectContext;
                
//     //           delete
//                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RetrieveInbox"];
//                NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
//                
//                NSError *deleteError = nil;
//                [[CoreDataManager instance].persistentStoreCoordinator executeRequest:delete withContext:[CoreDataManager instance].managedObjectContext error:&deleteError];
//                
                //insert
                NSError *error;
                NSArray *incomingCardsArray = [dictionary objectForKey:@"incoming"];
                
                for (int i = 0; i < incomingCardsArray.count; i++) {
                    RetrieveInbox *inbox = [MTLJSONAdapter modelOfClass:[RetrieveInbox class]
                                                     fromJSONDictionary:incomingCardsArray[i]
                                                                  error:&error];
                    
                    inbox.type = @"incoming";
                    
                    [MTLManagedObjectAdapter managedObjectFromModel:inbox
                                               insertingIntoContext:managedObjectContext
                                                              error:&error];
                }
                
                NSArray *outgoingCardsArray = [dictionary objectForKey:@"outgoing"];
                
                for (int i = 0; i < outgoingCardsArray.count; i++) {
                    RetrieveInbox *inbox = [MTLJSONAdapter modelOfClass:[RetrieveInbox class]
                                                     fromJSONDictionary:outgoingCardsArray[i]
                                                                  error:NULL];
                    
                    inbox.type = @"outgoing";
                    
                    [MTLManagedObjectAdapter managedObjectFromModel:inbox
                                               insertingIntoContext:managedObjectContext
                                                              error:&error];
                }
                // save context
                if (![managedObjectContext save:&error]) {
                    NSLog(@"managedObjectContext save - %@ %s %@", self.class, __func__, error.description);
                }
            }
            
            //            [subscriber sendNext:dataStoreModel];
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
            
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

- (RACSignal *)getRetrieveSingleCardWithIdent:(NSString *)ident {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *tenantURL = [NSString stringWithFormat:@"/share/%@",ident];
        [self.apiHttpClient GET:tenantURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSError *error = nil;
            CardModel *card = [MTLJSONAdapter modelOfClass:[CardModel class] fromJSONDictionary:responseObject error:&error];
            //            NSMutableDictionary * dict = [NSMutableDictionary new];
            //            [dict setObject:(Person *)[card person] forKey:@"person"];
            //            NSArray *pictures = [[responseObject objectForKey:@"person"] objectForKey:@"pictures"];
            //            [dict setObject:pictures forKey:@"pictures"];
            [subscriber sendNext:card];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [_apiHttpClient handleError:error];
        }];
        return nil;
    }];
}

@end
