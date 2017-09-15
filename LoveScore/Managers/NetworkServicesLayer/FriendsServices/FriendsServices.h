//
//  FriendsServicesImpl.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/18/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FriendsServices : NSObject

// get friends
- (RACSignal *)getFriendsWithLimit:(NSString *)limit andWithPage:(NSString *)page;
- (RACSignal *)getIncomingFriendsWithLimit:(NSString *)limit andWithPage:(NSString *)page savingToDatabase:(BOOL) saveToDatabase;
- (RACSignal *)getOutgoingFriendsWithLimit:(NSString *)limit andWithPage:(NSString *)page;

// search friends
- (RACSignal *)searchUsers:(NSString *)username;

// friends requests
- (RACSignal *)createFriendsRequest:(NSString *)username;
- (RACSignal *)acceptFriendsRequest:(NSString *)username;
- (RACSignal *)cancelFriendsRequest:(NSString *)username;
- (RACSignal *)rejectFriendsRequest:(NSString *)username;
- (RACSignal *)deleteFriendsRequest:(NSString *)username;

@end
