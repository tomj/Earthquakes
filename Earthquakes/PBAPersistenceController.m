//
//  PBAPersistenceController.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160130.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//
//  Credit: Marcus Zarra - http://martiancraft.com/blog/2015/03/core-data-stack/

@import CoreData;

#import "PBAPersistenceController.h"
#import "CacheTime.h"

NSString * const PBAPersistenceControllerEntityQuake        = @"Quake";
NSString * const PBAPersistenceControllerEntityCacheTime    = @"CacheTime";

@interface PBAPersistenceController ()

// property attributes here as reminders
@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong, readwrite) NSManagedObjectContext *privateContext;

@property (copy) InitCallbackBlock initCallback;

- (void)initializeCoreData;

@end

@implementation PBAPersistenceController

- (instancetype)initWithCallback:(InitCallbackBlock)callback;
{
    if (!(self = [super init])) return nil;

    [self setInitCallback:callback];
    [self initializeCoreData];

    return self;
}

- (void)initializeCoreData;
{
    // if managedObjectContext exists, return immediately
    if ([self managedObjectContext]) return;

    // locate model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSManagedObjectModel *MOM = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    // verify it initialized properly
    NSAssert(MOM, @"%@:%@ No model to generate store from.", [self class], NSStringFromSelector(_cmd));

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]
                                                 initWithManagedObjectModel:MOM];
    NSAssert(coordinator, @"Failed to init coordinator.");

    NSManagedObjectContext *mainMOC = [[NSManagedObjectContext alloc]
                                       initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self setManagedObjectContext:mainMOC];

    NSManagedObjectContext *privateMOC = [[NSManagedObjectContext alloc]
                                          initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self setPrivateContext:privateMOC];

    // set PSC for private MOC
    [self.privateContext setPersistentStoreCoordinator:coordinator];

    // set the parent context for main MOC
    [self.managedObjectContext setParentContext:self.privateContext];

    // reference the on disk data store
    // this takes an undetermined amount of time
    // to not block the main thread, perform these actions on a bg thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSPersistentStoreCoordinator *psc = [self.privateContext persistentStoreCoordinator];

        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];

        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];

        NSError *error;
        ZAssert([psc addPersistentStoreWithType:NSSQLiteStoreType
                                  configuration:nil
                                            URL:storeURL
                                        options:options
                                          error:&error],
                 @"Error initializing Persistent Store Coordinator: %@\n %@",
                 error.localizedDescription,
                 error.userInfo);

        if (!self.initCallback) return;

        // provided a callback was passed along
        // execute callback when above setup is complete
        // this will be the UI setup in the app delegate
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self initCallback]();
        });
    });
}

- (void)save;
{
    // if neither context has changes then return immediately
    if (! [self.privateContext hasChanges] && ![self.managedObjectContext hasChanges]) return;

    /*
     "we cannot guarantee that caller is the main thread, we use -performBlockAndWait: against the 
     main context to insure we are talking to it on its own terms."
     */
    [self.managedObjectContext performBlockAndWait:^{
        NSError *mainError;
        ZAssert([self.managedObjectContext save:&mainError],
                 @"Failed to save main context: %@ %@",
                 mainError.localizedDescription, mainError.userInfo);

        /*
         "Once the main context has saved then we move on to the private queue. 
         This queue can be asynchronous without any issues so we call -performBlock: on it and 
         then call save."
         */
        [self.privateContext performBlock:^{
            NSError *privateError;
            ZAssert([self.privateContext save:&privateError],
                     @"Failed to save private context: %@ %@",
                     privateError.localizedDescription, privateError.userInfo);
        }];
    }];
}

- (NSArray *)objectsFromEntity:(NSString *)entity;
{
    return [self objectsFromEntity:entity fetchRequest:nil];
}

- (NSArray *)objectsFromEntity:(NSString *)entity fetchRequest:(NSFetchRequest *)request;
{
    if (!request) {
        request = [[NSFetchRequest alloc] initWithEntityName:entity];
    }

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity
                                                         inManagedObjectContext:self.managedObjectContext];
    request.entity = entityDescription;

    NSError *error;
    NSArray *results = [self.privateContext executeFetchRequest:request error:&error];
    if (!results) {
        ZAssert(!results, @"Failed to fetch.");
        return nil;
    } else {
        return results;
    }
}

- (CacheTime *)lastCacheTimeRow;
{
    return [[self objectsFromEntity:PBAPersistenceControllerEntityCacheTime] lastObject];
}

- (void)insertNewCacheTimeRow;
{
    __block CacheTime *ct;
    __weak __typeof(self)weakSelf = self;
    [self.managedObjectContext performBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        ct = [NSEntityDescription insertNewObjectForEntityForName:PBAPersistenceControllerEntityCacheTime
                                           inManagedObjectContext:strongSelf.managedObjectContext];
        [strongSelf.self save];
    }];
}

@end

