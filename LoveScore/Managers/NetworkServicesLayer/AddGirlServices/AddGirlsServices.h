//
//  AddGirlsSrevices.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIHTTPClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AddGirlsServices : NSObject

- (RACSignal *)getPersonsWithLimit:(NSString *)limit andPage:(NSString *)page;

- (RACSignal *)uploadPersons;


@end
