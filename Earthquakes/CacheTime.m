//
//  CacheTime.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160128.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "CacheTime.h"

@implementation CacheTime

// Insert code here to add functionality to your managed object subclass

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.cachedAt = [NSDate new];
}

@end
