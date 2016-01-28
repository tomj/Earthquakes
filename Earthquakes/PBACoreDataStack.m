//
//  PBACoreDataStack.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "PBACoreDataStack.h"
#import "CacheTime.h"

@import Foundation;

NSString * const PBACoreDataStackSQLiteStore        = @"CoreDataStore";
NSString * const PBACoreDataStackEntityQuake        = @"Quake";
NSString * const PBACoreDataStackEntityCacheTime    = @"CacheTime";

@interface PBACoreDataStack ()

@property (copy, nonatomic) NSString *modelName;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation PBACoreDataStack

- (instancetype)initWithModelName:(NSString *)modelName;
{
    self = [super init];
    if (self) {
        _modelName = [modelName copy];

        // setup MOM
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName
                                                  withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        // setup PSC
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];

        // specify the name, indicating the type of store
        NSString *filename = [_modelName stringByAppendingPathExtension:@"sqlite"];

        // define the location of the store
        NSURL *storeURL = [[self cacheDirectory] URLByAppendingPathComponent:filename];
        NSLog(@"storeURL: %@", storeURL);
        NSError *error;

        // define the type for this store
        NSPersistentStore *persistentStore = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                               configuration:nil
                                                                         URL:storeURL
                                                                     options:nil
                                                                       error:&error];
        NSAssert(persistentStore != nil, @"Fatal: Could not instantiate the store.");
        _persistentStoreCoordinator = psc;

        // setup the main queue MOC
        NSManagedObjectContext *mqc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        mqc.persistentStoreCoordinator = _persistentStoreCoordinator;
        mqc.name = @"Main Queue Context";
        _mainQueueContext = mqc;
    }
    return self;
}

- (instancetype)init
{
    // TODO to constant
    return [self initWithModelName:PBACoreDataStackSQLiteStore];
}

- (NSURL *)cacheDirectory
{
    NSArray *url = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                          inDomains:NSUserDomainMask];
    NSURL *documentDirectory = url.firstObject;
    return documentDirectory;
}

- (void)saveManagedObjectContext:(NSManagedObjectContext *)moc;
{
    NSError *error;
    if (![moc save:&error]) {
        NSAssert(![moc save:&error], @"Save to MOC failed.");
    } else {
        NSLog(@"Save to MOC succeeded.");
    }
}

- (NSArray *)objectsFromEntity:(NSString *)entity
        inManagedObjectContext:(NSManagedObjectContext *)moc;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    NSEntityDescription *ed = [NSEntityDescription entityForName:entity inManagedObjectContext:moc];
    request.entity = ed;

//    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"magnitude" ascending:NO];
//    request.sortDescriptors = @[sd];

    NSError *error;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (!results) {
        NSAssert(!results, @"Failed to fetch.");
        return nil;
    } else {
        return results;
    }
}

- (CacheTime *)lastCacheAtDate;
{
    return [[self objectsFromEntity:PBACoreDataStackEntityCacheTime
             inManagedObjectContext:self.mainQueueContext] lastObject];
}

- (void)updatedCachedAtDate
{
    __block CacheTime *ct;
    __weak __typeof(self)weakSelf = self;

    [self.mainQueueContext performBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        ct = [NSEntityDescription insertNewObjectForEntityForName:PBACoreDataStackEntityCacheTime inManagedObjectContext:strongSelf.mainQueueContext];

        [strongSelf.self saveManagedObjectContext:strongSelf.mainQueueContext];
    }];
}

@end
