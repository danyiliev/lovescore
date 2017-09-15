//
//  Person.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/26/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "Person.h"
#import "CoreDataManager.h"
#import "DataStore.h"
#import "User.h"

@interface Person ()

@end

@implementation Person

- (UIImage *)flagImage
{
    if([[[CoreDataManager instance] getUser] fromUS]) {
        if(self.state) {
            return [UIImage imageNamed:[[[CoreDataManager instance] getDataStore] states][self.state]];
        }
        return [UIImage imageNamed:self.nationality];
    } else {
        return [UIImage imageNamed:self.nationality];
    }
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"age" : @"current_age",
             @"attributes" : @"attributes",
             @"category" : @"category",
             @"comment" : @"comment",
             @"country" : @"country",
             @"dateOfBirth" : @"date_of_birth",
             @"events" : @"events",
             @"firstName" : @"first_name",
             @"hairColor" : @"hair_color",
             @"uuid" : @"uuid",
             @"job" : @"job",
             @"lastName" : @"last_name",
             @"location" : @"location",
             @"nationality" : @"nationality",
             @"phoneNumber" : @"phone_number",
             @"rating" : @"rating",
             @"socialMedia" : @"social_media",
             @"status" : @"status",
             @"city" : @"city",
             @"personRatings" : @"ratings",
             @"createdAt" : @"created_at",
             @"state" : @"nationality_state"
             };
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


#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"Person";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"age" : @"age",
             @"attributes" : @"attributes",
             @"category" : @"category",
             @"comment" : @"comment",
             @"country" : @"country",
             @"dateOfBirth" : @"dateOfBirth",
             @"events" : @"events",
             @"firstName" : @"firstName",
             @"hairColor" : @"hairColor",
             @"uuid" : @"uuid",
             @"job" : @"job",
             @"lastName" : @"lastName",
             @"nationality" : @"nationality",
             @"phoneNumber" : @"phoneNumber",
             @"rating" : @"rating",
             @"socialMedia" : @"socialMedia",
             @"status" : @"status",
             @"city" : @"city",
             @"personRatings" : @"personRatings",
             @"createdAt" : @"createdAt",
             @"state" : @"state"
             };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"uuid"];
}

- (void)setNilValueForKey:(NSString *)key {
    [self setValue:@0 forKey:key];
}


@end
