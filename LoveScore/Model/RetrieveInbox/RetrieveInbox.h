//
//  RetrieveInbox.h
//  LoveScore
//
//  Created by Oleksandr on 12/17/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface RetrieveInbox : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, strong) NSString *ident;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSDictionary *relatedUser;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *nationality;
@property (nonatomic, strong) NSString *createdAt;

@property (nonatomic, strong) NSString *type;

@end
