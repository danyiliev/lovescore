//
//  PicturesEntity+CoreDataProperties.h
//  
//
//  Created by Oleksandr Shymanskyi on 12/31/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PicturesEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PicturesEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSArray *pictures;
@property (nullable, nonatomic, retain) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
