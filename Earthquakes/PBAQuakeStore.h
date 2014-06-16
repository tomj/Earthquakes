//
//  PBAQuakeStore.h
//  Earthquakes
//
//  Created by Pouria Almassi on 2/6/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBAQuake;

@interface PBAQuakeStore : NSObject

+ (PBAQuakeStore *)sharedStore;
- (void)downloadDataWithCompletion:(void (^)(NSArray *quakes, NSError *error))completion;

@end
