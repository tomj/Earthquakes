//
//  PBACoreDataStack.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

@import Foundation;
@import CoreData;

@class CacheTime;

extern NSString * const PBACoreDataStackSQLiteStore;
extern NSString * const PBACoreDataStackEntityQuake;
extern NSString * const PBACoreDataStackEntityCacheTime;

@interface PBACoreDataStack : NSObject

@property (nonatomic) NSManagedObjectContext *mainQueueContext;

- (instancetype)initWithModelName:(NSString *)modelName NS_DESIGNATED_INITIALIZER;
- (void)saveManagedObjectContext:(NSManagedObjectContext *)moc;
- (NSArray *)objectsFromEntity:(NSString *)entity inManagedObjectContext:(NSManagedObjectContext *)moc;
- (void)updatedCachedAtDate;
- (CacheTime *)lastCacheAtDate;

@end
