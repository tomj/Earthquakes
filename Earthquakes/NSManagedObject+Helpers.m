//
//  NSManagedObject+Helpers.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160202.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "NSManagedObject+Helpers.h"

@implementation NSManagedObject (Helpers)

+ (NSString *)entityName;
{
    return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectInContext:(NSManagedObjectContext *)context;
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:context];
}

@end
