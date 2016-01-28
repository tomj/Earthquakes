//
//  CacheTime+CoreDataProperties.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160128.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CacheTime.h"

NS_ASSUME_NONNULL_BEGIN

@interface CacheTime (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *cachedAt;

@end

NS_ASSUME_NONNULL_END
