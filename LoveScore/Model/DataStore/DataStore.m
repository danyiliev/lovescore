//
//  DataStore.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

#pragma mark - MTLJSONSerializing


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"attributes" : @"attributes",
             @"categories" : @"categories",
             @"countries" : @"countries",
             @"jobs" : @"jobs",
             @"locations" : @"locations",
             @"countries" : @"countries",
             @"socialMedia" : @"social_media",
             @"internationalisation" : @"i18n",
             @"hairColor" : @"hair_colors",
             @"nationality" : @"nationalities",
             @"states" : @"states"
             };
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"DataStore";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"attributes" : @"attributes",
             @"categories" : @"categories",
             @"countries" : @"countries",
             @"jobs" : @"jobs",
             @"locations" : @"locations",
             @"countries" : @"countries",
             @"socialMedia" : @"socialMedia",
             @"internationalisation" : @"internationalisation",
             @"hairColor" : @"hairColor",
             @"nationality" : @"nationality",
             @"states" : @"states"
             };
}

@end
