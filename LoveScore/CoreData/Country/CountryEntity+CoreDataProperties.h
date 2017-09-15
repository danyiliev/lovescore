//
//  CountryEntity+CoreDataProperties.h
//  
//
//  Created by Roman Sakhnievych on 12/2/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CountryEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CountryEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDictionary *country;

@end

NS_ASSUME_NONNULL_END
