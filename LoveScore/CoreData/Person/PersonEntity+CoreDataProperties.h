//
//  PersonEntity+CoreDataProperties.h
//  
//
//  Created by Oleksandr Shymanskyi on 12/29/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PersonEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonEntity (CoreDataProperties)


@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSArray *attributes;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSDictionary *city;
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSDate *dateOfBirth;
@property (nullable, nonatomic, retain) NSMutableDictionary *events;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *hairColor;
@property (nullable, nonatomic, retain) NSString *job;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *nationality;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSDictionary *socialMedia;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSDictionary *personRatings;
@property (nullable, nonatomic, retain) NSString *createdAt;
@property (nullable, nonatomic, retain) NSString *state;


@end

NS_ASSUME_NONNULL_END
