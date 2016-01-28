//
//  Quake+CoreDataProperties.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Quake.h"

NS_ASSUME_NONNULL_BEGIN

@interface Quake (CoreDataProperties)

@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *depth;
@property (nonatomic, retain) NSNumber *magnitude;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSDate *dateTime;

@end

NS_ASSUME_NONNULL_END
