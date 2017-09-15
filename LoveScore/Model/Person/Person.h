//
//  Person.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/26/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Person : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSArray *attributes;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSDate *dateOfBirth;
@property (nullable, nonatomic, retain) NSMutableDictionary *events;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *hairColor;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSString *job;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *nationality;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSDictionary *socialMedia;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSDictionary *city;
@property (nullable, nonatomic, retain) NSDictionary *personRatings;
@property (nullable, nonatomic, retain) NSString *createdAt;
@property (nullable, nonatomic, retain) NSString *state;

- (nonnull UIImage *)flagImage;

@end
