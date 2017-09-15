//
//  FriendsEntity+CoreDataProperties.h
//  
//
//  Created by Oleksandr Shymanskyi on 11/18/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FriendsEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSString *state;

@end

NS_ASSUME_NONNULL_END
