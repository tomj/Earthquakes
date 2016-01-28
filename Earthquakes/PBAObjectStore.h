//
//  PBAStore.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

@import Foundation;
@import CoreData;

@class PBAWebService;
@class PBACoreDataStack;

@interface PBAObjectStore : NSObject

@property (nonatomic) PBAWebService *webService;
@property (nonatomic) PBACoreDataStack *coreDataStack;

- (instancetype)initWithCoreDataStack:(PBACoreDataStack *)cds webService:(PBAWebService *)ws;

@end
