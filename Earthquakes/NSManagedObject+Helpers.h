//
//  NSManagedObject+Helpers.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160202.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helpers)

+ (NSString *)entityName;
+ (instancetype)insertNewObjectInContext:(NSManagedObjectContext *)context;

@end
