//
//  PBAPersistenceController.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160130.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

@import Foundation;
@import CoreData;

@class CacheTime;

extern NSString * const PBAPersistenceControllerEntityQuake;
extern NSString * const PBAPersistenceControllerEntityCacheTime;

typedef void (^InitCallbackBlock)(void);

@interface PBAPersistenceController : NSObject

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithCallback:(InitCallbackBlock)callback;
- (void)save;

- (NSArray *)quakes;

- (CacheTime *)lastCacheTimeRow;
- (void)insertNewCacheTimeRow;

@end
