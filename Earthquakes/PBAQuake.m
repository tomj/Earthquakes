//
//  PBAQuake.m
//  Earthquakes
//
//  Created by Pouria Almassi on 2/6/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import "PBAQuake.h"

@implementation PBAQuake

- (NSString *)description
{
    NSString *descr = [NSString stringWithFormat:@"%@ / %@ / %@ / %g / %g / %f / %f / %@",
                       self.location,
                       self.link,
                       self.quakeTitle,
                       self.depth,
                       self.magnitude,
                       self.latitude,
                       self.longitude,
                       self.dateTime];
    return descr;
}

@end
