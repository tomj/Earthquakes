//
//  PBAStore.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "PBAObjectStore.h"
#import "PBACoreDataStack.h"
#import "PBAWebService.h"

NSString * const PBAObjectStoreCoreDataStackModelName   = @"CoreDataStore";
NSString * const PBAObjectStoreCoreDataEntityQuake      = @"Quake";

@implementation PBAObjectStore

- (instancetype)initWithCoreDataStack:(PBACoreDataStack *)cds webService:(PBAWebService *)ws
{
    self = [super init];
    if (self) {
        _coreDataStack = cds;
        _webService = ws;
        _webService.coreDataStack = _coreDataStack;
    }
    return self;
}

@end
