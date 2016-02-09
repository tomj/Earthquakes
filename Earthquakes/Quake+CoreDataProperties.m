//
//  Quake+CoreDataProperties.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Quake+CoreDataProperties.h"

@implementation Quake (CoreDataProperties)

@dynamic location;
@dynamic title;
@dynamic depth;
@dynamic magnitude;
@dynamic latitude;
@dynamic longitude;
@dynamic dateTime;

@end
