//
//  DataStoreEntity+CoreDataProperties.h
//  
//
//  Created by Roman Sakhnievych on 12/4/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DataStoreEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataStoreEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSArray *attributes;
@property (nullable, nonatomic, retain) NSArray *categories;
@property (nullable, nonatomic, retain) NSDictionary *countries;
@property (nullable, nonatomic, retain) NSDictionary *internationalisation;
@property (nullable, nonatomic, retain) NSArray *jobs;
@property (nullable, nonatomic, retain) NSArray *locations;
@property (nullable, nonatomic, retain) NSArray *ratings;
@property (nullable, nonatomic, retain) NSArray *socialMedia;
@property (nullable, nonatomic, retain) NSArray *hairColor;
@property (nullable, nonatomic, retain) NSDictionary *nationality;
@property (nullable, nonatomic, retain) NSDictionary *states;

@end

NS_ASSUME_NONNULL_END
