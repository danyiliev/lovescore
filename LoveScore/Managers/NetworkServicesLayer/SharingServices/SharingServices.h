//
//  SharingServicesImpl.h
//  LoveScore
//
//  Created by Oleksandr on 12/17/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareCard.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface SharingServices : NSObject

- (RACSignal *)shareCardWithModel:(ShareCard *)shareCard;
- (RACSignal *)getRetrieveInboxWithLimit:(NSInteger)limit andWithPage:(NSInteger)page savingToDatabase:(BOOL)saveToDatabase;
- (RACSignal *)getRetrieveSingleCardWithIdent:(NSString *)ident;

@end
