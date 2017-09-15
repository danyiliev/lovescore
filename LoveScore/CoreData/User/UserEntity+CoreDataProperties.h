//
//  UserEntity+CoreDataProperties.h
//  
//
//  Created by Oleksandr Shymanskyi on 1/15/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserEntity (CoreDataProperties)


@property (nullable, nonatomic, retain) NSString *avatarUrl;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSDate *dateOfBirth;
@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSDictionary *city;
@property (nullable, nonatomic, retain) NSString *language;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSDictionary *generalNotification;
@property (nullable, nonatomic, retain) NSDictionary *girlsNotification;
@property (nullable, nonatomic, retain) NSDictionary *friendsNotification;


@end

NS_ASSUME_NONNULL_END
