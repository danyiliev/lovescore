//
//  CoreDataManager.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 11/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "CoreDataManager.h"
#import "Person.h"
#import "PersonEntity.h"
#import "DataStore.h"
#import "DataStoreEntity.h"
#import "SyncManager.h"
#import "User.h"
#import "UserEntity.h"

@implementation CoreDataManager
{
    DataStore *_dataStore;
    User *_user;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)instance {
    static CoreDataManager *dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [CoreDataManager new];
    });
    return dbManager;
}

- (void)setup {
    [self managedObjectContext];
}

- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LoveScore" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LoveScore.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark --
- (NSManagedObject *)insertNewManagedObject:(NSString *)name {
    NSManagedObject *newEntity = [NSEntityDescription
                                  insertNewObjectForEntityForName:name
                                  inManagedObjectContext:([self managedObjectContext])];
    return newEntity;
}

#pragma markr - Public methods
// method which return Array of girls of Person:MTLModel type
- (NSArray *)getGirlsFromDataBase {
    NSMutableArray *persons = [NSMutableArray new];
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSPredicate *lPredicate = [NSPredicate predicateWithFormat:@"(SELF.status == %@)", @"ACT"];
    [lFetchRequest setPredicate:lPredicate];
    [lFetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *lError = nil;
    NSArray *lReturn = [self.managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    for (PersonEntity *personEntity in lReturn) {
        Person *person = [MTLManagedObjectAdapter modelOfClass:[Person class] fromManagedObject:personEntity error:&lError];
        [persons addObject:person];
    }
    
    return persons;
}

- (NSDictionary *)getCountriesDictionaryFromDataBase {
    
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    
    DataStoreEntity *data = (DataStoreEntity *)lReturn[0];
    DataStore *dataStore = [MTLManagedObjectAdapter modelOfClass:[DataStore class] fromManagedObject:data error:&lError];
    
    NSLog(@"data - %@", data);
    if (lError != nil) {
        NSLog(@"%@ %s %@", self.class, __func__, lError.description);
    }
    
    NSDictionary *countriesDictionary = [dataStore.internationalisation objectForKey:@"countries"];
    return countriesDictionary;
}

- (NSArray *)cleanDeletedPerson {
    
    NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    lFetchRequest.predicate = [NSPredicate predicateWithFormat:@"status == %@", @"DEL"];
    
    NSError *lError = nil;
    NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (PersonEntity *person in lReturn) {
        [array addObject:(PersonEntity *)person.uuid];
        [self.managedObjectContext deleteObject:person];
    }
    
    return array;
}

- (DataStore *)getDataStore {
    if(!_dataStore) {
        NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataStore"];
        NSError *lError = nil;
        NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
        
        DataStoreEntity *data = (DataStoreEntity *)lReturn[0];
        _dataStore = [MTLManagedObjectAdapter modelOfClass:[DataStore class] fromManagedObject:data error:&lError];
    }
    return _dataStore;
}

- (User *)getUser {
    if(!_user) {
        NSFetchRequest *lFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        
        NSError *lError = nil;
        NSArray *lReturn = [[CoreDataManager instance].managedObjectContext executeFetchRequest:lFetchRequest error:&lError];
        if (lReturn && lReturn.count > 0) {
            UserEntity *userEntity = (UserEntity *)lReturn[0];
            _user = [MTLManagedObjectAdapter modelOfClass:[User class] fromManagedObject:userEntity error:&lError];
            
            if (lError != nil) {
                NSLog(@"%@ %s %@", self.class, __func__, lError.description);
            }
            return _user;
        }
    }
    return _user;
}

- (void)cleanCoreData {
    _user = nil;
    _dataStore = nil;
    [self clearEntityWithName:@"User"];
    
    [self clearEntityWithName:@"Pictures"];
    
    [self clearEntityWithName:@"Friends"];
    
    [self clearEntityWithName:@"RetrieveInbox"];
    
    [self clearEntityWithName:@"Person"];
}

- (void)clearEntityWithName:(NSString *)name {
    
    NSFetchRequest * allMovies = [[NSFetchRequest alloc] init];
    [allMovies setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext]];
    [allMovies setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * movies = [self.managedObjectContext executeFetchRequest:allMovies error:&error];
    //error handling goes here
    for (NSManagedObject * movie in movies) {
        [self.managedObjectContext deleteObject:movie];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

@end
