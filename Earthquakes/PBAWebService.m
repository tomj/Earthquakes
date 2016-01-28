//
//  PBAWebService.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

@import CoreData;

// Model
#import "Quake.h"
#import "CacheTime.h"

// Other
#import "PBAWebService.h"
#import "PBACoreDataStack.h"
#import "NSDate+Utilities.h"

NSString * const PBAWebServiceBaseURL = @"http://earthquake-report.com/feeds/";

@interface PBAWebService ()

@property (nonatomic) NSURLSession *session;

@end

@implementation PBAWebService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _session = [NSURLSession sharedSession];
    }
    return self;
}

- (void)getObjectsWithCompletion:(void (^)(NSArray *objects, NSError *error))completion;
{
    CacheTime *ct = [self.coreDataStack lastCacheAtDate];
    NSLog(@"Last cached at: %@", ct.cachedAt);
    NSInteger diff = [[NSDate new] hoursAfterDate:ct.cachedAt];
    NSLog(@"hour diff: %lul", (unsigned long)diff);

    //    ----------------------------------------------------------------------
    //    retrieve from cache
    //    ----------------------------------------------------------------------

    //    if (timeSinceLastCache && timeSinceLastCache < 24HOURS) {
    if (ct.cachedAt && diff < 24) {
        NSLog(@"pull from cache");

        NSArray *objects = [self.coreDataStack objectsFromEntity:PBACoreDataStackEntityQuake
                                          inManagedObjectContext:self.coreDataStack.mainQueueContext];
        if (objects) {
            completion(objects, nil);
        } else {
            // TODO return an error
            completion(nil, nil);
        }
    }
    //    ----------------------------------------------------------------------
    //    retrieve from webservice
    //    ----------------------------------------------------------------------
    else {
        NSLog(@"pull from ws");
        NSString *path = [NSString stringWithFormat:@"%@%@", PBAWebServiceBaseURL, @"recent-eq?json"];
        NSURL *url = [NSURL URLWithString:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        __weak __typeof(self)weakSelf = self;
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;

            if (data) {
                NSArray *objects = [self objectsFromJSONData:data inContext:strongSelf.coreDataStack.mainQueueContext];

                /*
                 options:
                 1) dump old cache results.
                 2) leave previous results
                 a) and only provide results from the last 24 hours.
                 b) pull all?
                 - get new objects
                 - update
                 - cacheUpdatedAt = [NSDate new];
                 */

                [strongSelf.coreDataStack updatedCachedAtDate];

                completion(objects, nil);
            } else {
                completion(nil, error);
            }
        }];
        [task resume];

    }
}

- (NSArray *)objectsFromJSONData:(NSData *)data inContext:(NSManagedObjectContext *)context
{
    NSMutableArray *objects = [NSMutableArray array];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (jsonDict != nil) {
        for (NSDictionary *d in jsonDict) {
            Quake *anObject = [self createAndCacheObjectFromJSON:d inContext:context];
            [objects addObject:anObject];
        }
    } else {
        NSLog(@"TODO better error handling. jsonDict is nil");
    }
    return objects;
}

- (Quake *)createAndCacheObjectFromJSON:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    NSString *location = [dictionary objectForKey:@"location"];
    NSString *title = [dictionary objectForKey:@"title"];
    NSNumber *depth = [NSNumber numberWithDouble:[[dictionary objectForKey:@"depth"] doubleValue]];
    NSNumber *magnitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"magnitude"] doubleValue]];
    NSNumber *latitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"latitude"] doubleValue]];
    NSNumber *longitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"longitude"] doubleValue]];
    NSDate *dateTime = [[NSDate alloc] init];

    if (!location || !title || !depth || !magnitude || !latitude || !longitude || !dateTime) {
        return nil;
    }

    __block Quake *quake;

    // insert obj into MOC
    __weak __typeof(self)weakSelf = self;

    // Synchronously performs a given block on the receiver’s queue.
    [context performBlockAndWait:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        // create obj
        quake = [NSEntityDescription insertNewObjectForEntityForName:PBACoreDataStackEntityQuake inManagedObjectContext:context];
        quake.location = location;
        quake.title = title;
        quake.depth = depth;
        quake.magnitude = magnitude;
        quake.latitude = latitude;
        quake.longitude = longitude;
        quake.dateTime = dateTime;

        // save obj to moc
        [strongSelf.coreDataStack saveManagedObjectContext:context];
    }];
    return quake;
}

@end
