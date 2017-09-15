//
//  APIHTTPClient.m
//  Movebox
//
//  Created by  Кирилл Легкодух on 14.09.15.
//  Copyright (c) 2015 Kira Company. All rights reserved.
//

#import "APIHTTPClient.h"
#import "AppDelegate.h"
#import "SyncManager.h"
NSString *const BASE_URL = @"http://pp.lovescoreapp.com";


@implementation APIHTTPClient

+ (instancetype)sharedAPIHTTPClient
{
    static APIHTTPClient *_sharedInstance;
    
    if (!_sharedInstance) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedInstance = [[self alloc] initPrivat];
        });
    }
    
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[APIHTTPClient sharedAPIHTTPClient]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivat
{
    self = [super initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil] ;
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setTimeoutInterval:15];  //Time out after 25 seconds
        self.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    }
    
    return self;
}

- (NSDictionary *)handleError:(NSError *)error {
    NSDictionary *userInfo = error.userInfo;
    NSLog(@"Handle Error = %@\n", error);
    NSData *data = [userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];

    NSDictionary *json;
    if (data) {
        NSError *serialError;
        json = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:0 error:&serialError];
        if (serialError) {
            NSLog(@"%@",serialError);
            return nil;
        } else {
            NSLog(@"Response data = %@", json);
     }
    }
    
    if (json && [json objectForKey:@"code"] && [[json objectForKey:@"code"] integerValue] == 110) {
        AppDelegate *appDelegate = APP_DELEGATE;
        [appDelegate.window.rootViewController showAlertControllerWithTitle:@"" withMessage:@"Oops, something went wrong. Please log in again." withCompletion:^{
            [[SyncManager sharedInstance] logOut];
        }];
    }
    
    return json;
}

-(NSString *)processParsedObject:(id)object{
    NSString *errorMsg = nil;
    if ([object objectForKey:@"error_description"] != nil) {
        errorMsg = [object objectForKey:@"error_description"];
        return errorMsg;
    }
    if ([object objectForKey:@"message"] != nil) {
        errorMsg = [object objectForKey:@"message"];
    }
    if ([self processParsedObject:object message:@"Error" parent:nil]) {
        errorMsg = [self processParsedObject:object message:@"Error" parent:nil];
    }
    
    return errorMsg;
}

-(NSString *)processParsedObject:(id)object message:(NSString *)msg parent:(id)parent{
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        for(NSString * key in [object allKeys]){
            if (![key isEqualToString:@"code"]) {
                id child = [object objectForKey:key];
                msg = [self processParsedObject:child message:msg parent:object];
            }
        }
    } else if([object isKindOfClass:[NSArray class]]) {
        
        for(id child in object){
            msg = [self processParsedObject:child message:msg parent:object];
        }
        
    } else {
        //This object is not a container you might be interested in it's value
        if (![[object description] isEqualToString:@""]) {
            NSLog(@"Node: %@", [object description]);
            msg = [object description];
        }
    }
    
    return msg;
}

- (void)showErrorAlertWithDescription:(NSString *)description {
   dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(showErrorMessageInAlertController:)]) {
            [self.delegate performSelector:@selector(showErrorMessageInAlertController:) withObject:description];
        }
        
    });
}

#pragma mark - OPTION implementation


- (NSURLSessionDataTask *)OPTION:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURL* URL = [NSURL URLWithString:[BASE_URL stringByAppendingString:URLString]];
    
    NSDictionary* URLParams = parameters;
    
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"OPTIONS";
    
    // Headers
    
    [request addValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"] forHTTPHeaderField:@"X-LoveScore-Token"];
    
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            if (success) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                success(dict);
            }
            NSLog(@"URL Session Task Succeeded: HTTP %ld", (long)((NSHTTPURLResponse*)response).statusCode);
        }
        else {
            // Failure
            
            if (failure) {
                failure(error);
            }
            
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
    
    return task;
}

/**
 This creates a new query parameters string from the given NSDictionary. For
 example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
 string will be @"day=Tuesday&month=January".
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           NSStringFromQueryParameters(queryParameters)
                           ];
    return [NSURL URLWithString:URLString];
}


@end
