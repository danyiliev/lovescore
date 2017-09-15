//
//  CoreDataManager.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataStore.h"

@class User;

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


+ (instancetype)instance;
- (void)setup;


- (NSManagedObject *)insertNewManagedObject:(NSString *)name;

- (NSArray *)getGirlsFromDataBase;
- (NSDictionary *)getCountriesDictionaryFromDataBase;

- (NSArray *)cleanDeletedPerson;
- (DataStore *)getDataStore;
- (User *)getUser;
- (void)cleanCoreData;

@end