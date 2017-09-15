//
//  CardEntity+CoreDataProperties.h
//  
//
//  Created by Roman Sakhnievych on 2/8/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CardEntity.h"


NS_ASSUME_NONNULL_BEGIN

@interface CardEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *ident;
@property (nullable, nonatomic, retain) NSString *card_type;
@property (nullable, nonatomic, retain) NSDictionary *friend;
@property (nullable, nonatomic, retain) NSDictionary *person;
@property (nullable, nonatomic, retain) NSDate *expire_date;

@end

NS_ASSUME_NONNULL_END
