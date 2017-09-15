//
//  RetrieveInbox.m
//  LoveScore
//
//  Created by Oleksandr on 12/17/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "RetrieveInbox.h"

@implementation RetrieveInbox

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"ident" : @"ident",
             @"status" : @"status",
             @"cardType" : @"card_type",
             @"relatedUser" : @"related_user",
             @"rating" : @"rating",
             @"nationality" : @"nationality",
             @"createdAt" : @"created_at"
             };
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"RetrieveInbox";
}


+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"ident" : @"ident",
             @"status" : @"status",
             @"cardType" : @"cardType",
             @"relatedUser" : @"relatedUser",
             @"rating" : @"rating",
             @"nationality" : @"nationality",
             @"createdAt" : @"createdAt",
             @"type" : @"type"
             };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"ident"];
}



@end
