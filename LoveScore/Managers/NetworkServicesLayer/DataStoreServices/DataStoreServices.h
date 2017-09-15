//
//  DataStoreServicesImpl.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/13/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface DataStoreServices : NSObject

- (RACSignal *)getCitiesListWithSearchWord:(NSString *)searchWord inCountry:(NSString *)countryCode;

- (RACSignal *)getDataStore;

@end
