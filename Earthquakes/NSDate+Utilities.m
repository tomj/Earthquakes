//
//  NSDate+Utilities.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160128.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

- (NSTimeInterval)secondsSinceDate:(NSDate *)aDate;
{
    return [self timeIntervalSinceDate:aDate];
}

@end
