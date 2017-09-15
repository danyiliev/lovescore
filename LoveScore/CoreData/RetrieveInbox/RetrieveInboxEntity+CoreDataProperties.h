//
//  RetrieveInboxEntity+CoreDataProperties.h
//  
//
//  Created by Roman Sakhnievych on 12/22/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RetrieveInboxEntity.h"


NS_ASSUME_NONNULL_BEGIN

@interface RetrieveInboxEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cardType;
@property (nullable, nonatomic, retain) NSString *createdAt;
@property (nullable, nonatomic, retain) NSString *ident;
@property (nullable, nonatomic, retain) NSString *nationality;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSDictionary *relatedUser;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *type;

@end

NS_ASSUME_NONNULL_END
