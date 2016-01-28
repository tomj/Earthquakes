//
//  NSDate+Utilities.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160128.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "NSDate+Utilities.h"

#define D_HOUR  3600.0

@implementation NSDate (Utilities)

// Credit to Erica Sadun
// https://github.com/erica/NSDate-Extensions/blob/master/NSDate%2BUtilities.m
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
{
    NSTimeInterval timeInterval = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (timeInterval / D_HOUR);
}

@end
