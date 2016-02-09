//
//  Quake.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "Quake.h"

@implementation Quake

// Insert code here to add functionality to your managed object subclass

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.location = @"";
    self.title = @"";
    self.depth = @0;
    self.magnitude = @0;
    self.latitude = @0;
    self.longitude = @0;
    self.dateTime = [NSDate new];
}

@end
