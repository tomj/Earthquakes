//
//  PBAWebService.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBAPersistenceController;

@interface PBAWebService : NSObject

- (instancetype)initWithPersistenceController:(PBAPersistenceController *)persistenceController;
- (void)getObjectsWithCompletion:(void (^)(NSArray *objects, NSError *error))completion;

@end
