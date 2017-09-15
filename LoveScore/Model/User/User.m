//
//  User.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 12/25/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "User.h"

@implementation User
{
    BOOL _fromUS;
}

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"username" : @"username",
             @"displayName" : @"display_name",
             @"email" : @"email",
             @"dateOfBirth" : @"date_of_birth",
             @"language" : @"language",
             @"country" : @"country",
             @"city" : @"city",
             @"createdAt" : @"created_at",
             @"avatarUrl" : @"avatar_url"
             };
}

- (void)setCountry:(NSString *)country
{
    _country = country;
    _fromUS = [country isEqualToString:@"US"];
}

+ (NSDateFormatter*)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return dateFormatter;
}

+ (NSValueTransformer *)dateOfBirthJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"User";
}

+(NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"username" : @"username",
             @"displayName" : @"displayName",
             @"email" : @"email",
             @"dateOfBirth" : @"dateOfBirth",
             @"language" : @"language",
             @"country" : @"country",
             @"createdAt" : @"createdAt",
             @"avatarUrl" : @"avatarUrl",
             @"generalNotification" : @"generalNotification",
             @"girlsNotification" : @"girlsNotification",
             @"friendsNotification" : @"friendsNotification",
             @"city" : @"city"
             };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"username"];
}


-(void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key];
}

- (BOOL)fromUS
{
    return _fromUS;
}

@end
