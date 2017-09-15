//
//  DataStore.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <CoreData/CoreData.h>

@interface DataStore : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nullable, nonatomic, copy) NSArray *attributes;
@property (nullable, nonatomic, copy) NSArray *categories;
@property (nullable, nonatomic, copy) NSDictionary *countries;
@property (nullable, nonatomic, copy) NSArray *jobs;
@property (nullable, nonatomic, copy) NSArray *locations;
@property (nullable, nonatomic, copy) NSArray *ratings;
@property (nullable, nonatomic, copy) NSArray *socialMedia;
@property (nullable, nonatomic, copy) NSDictionary *internationalisation;
@property (nullable, nonatomic, copy) NSArray *hairColor;
@property (nullable, nonatomic, copy) NSDictionary *nationality;
@property (nullable, nonatomic, copy) NSDictionary *states;


@end
