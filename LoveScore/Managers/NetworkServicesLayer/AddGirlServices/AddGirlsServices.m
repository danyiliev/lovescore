//
//  AddGirlsSrevices.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "AddGirlsServices.h"
#import "NetworkActivityIndicator.h"
#import "APIHTTPClient.h"
#import "CoreDataManager.h"
#import "PicturesEntity.h"
#import "Person.h"
#import "PersonEntity.h"
#import "ImageManager.h"

@interface AddGirlsServices () <APIHTTPClientDelegate>

@property (strong, nonatomic) APIHTTPClient *apiHttpClient;

@end

@implementation AddGirlsServices

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

- (RACSignal *)getPersonsWithLimit:(NSString *)limit andPage:(NSString *)page {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL = [NSString stringWithFormat:@"/persons?limit=%@&page=%@", limit, page];
        
        [self.apiHttpClient GET:tenantURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            // setup girls textual info
            
            NSArray *girlsArray = [responseObject objectForKey:@"data"];
            
            NSManagedObjectContext *managedObjectContext = [CoreDataManager instance].managedObjectContext;
            
            NSError *error;
            
            for(NSDictionary *girl in girlsArray) {
                
                // setup girls
                Person *person = [MTLJSONAdapter modelOfClass:[Person class]
                                           fromJSONDictionary:girl
                                                        error:&error];
                
                [MTLManagedObjectAdapter managedObjectFromModel:person
                                           insertingIntoContext:managedObjectContext
                                                          error:&error];
                if (error) {
                    NSLog(@"getPersonsWithLimit request, Error - %@", error);
                }
                
                //             save context
                if (![managedObjectContext save:&error]) {
                    NSLog(@"getPersonsWithLimit request, managedObjectContext save - %@ %s %@", self.class, __func__, error.description);
                }
                
                //                [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
                
                //                [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoaderWithText:@"Downloading images"];
                
                // setup girls images
                
                PicturesEntity *picturesEntity = (PicturesEntity *)[[CoreDataManager instance] insertNewManagedObject:@"Pictures"];
                
                picturesEntity.uuid = [girl objectForKey:@"uuid"];
                picturesEntity.pictures = [girl objectForKey:@"pictures"];
                [[CoreDataManager instance] saveContext];
                
            }
            [subscriber sendNext:[responseObject objectForKey:@"pagination"]];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];
            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        
        return nil;
    }];
}

- (RACSignal *)uploadPersons {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *tenantURL = @"/persons";
        
        [[NetworkActivityIndicator sharedNetworkActivityIndicator] showLoader];
        
        NSArray *girlsArray = [self getGirlsFromDataBase];
        
        NSMutableArray *jsonGirlsArray = [NSMutableArray new];
        
        for (int i = 0; i < girlsArray.count; i++) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithDictionary:
                                               [MTLJSONAdapter JSONDictionaryFromModel:girlsArray[i]]];
            
            NSDictionary *cityDict = [dictionary objectForKey:@"city"];
            
            if (![cityDict isEqual:[NSNull null]]) {
                NSString *cityId = [cityDict objectForKey:@"place_id"];
                
                [dictionary setObject:cityId forKey:@"city_place_id"];
                [dictionary removeObjectForKey:@"city"];
            }
            
            NSArray *allKeys = [dictionary allKeys];
            for (NSString *key in allKeys) {
                if ([[dictionary objectForKey:key] isEqual:[NSNull null]]) {
                    [dictionary removeObjectForKey:key];
                }
            }
            [jsonGirlsArray addObject:[dictionary copy]];
        }
        
        NSLog(@"%@", jsonGirlsArray);
        
        // add girls array to JSON
        NSMutableDictionary *parametersJson = [NSMutableDictionary new];
        [parametersJson setObject:jsonGirlsArray forKey:@"persons"];
        //some changes
        
        //add currnet time as sync time
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        
        [parametersJson setObject:dateString forKey:@"last_sync_stamp"];
        
        [self.apiHttpClient POST:tenantURL parameters:parametersJson success:^(NSURLSessionDataTask *task, id responseObject) {

            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_apiHttpClient handleError:error];

            [subscriber sendError:error];

            [[NetworkActivityIndicator sharedNetworkActivityIndicator] hideLoader];
        }];
        return nil;
    }];
}

- (NSArray *)getGirlsFromDataBase {
    NSMutableArray *persons = [NSMutableArray new];
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    [lFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *lError = nil;
    NSArray *lReturn = [[[CoreDataManager instance] managedObjectContext] executeFetchRequest:lFetchRequest error:&lError];
    for (PersonEntity *personEntity in lReturn) {
        Person *person = [MTLManagedObjectAdapter modelOfClass:[Person class] fromManagedObject:personEntity error:&lError];
        [persons addObject:person];
    }
    
    return persons;
}

@end
