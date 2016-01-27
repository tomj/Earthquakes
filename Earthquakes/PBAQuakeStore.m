//
//  PBAQuakeStore.m
//  Earthquakes
//
//  Created by Pouria Almassi on 2/6/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import "PBAQuakeStore.h"
#import "PBAQuake.h"

NSString * const PBAQuakeStoreBaseURLString = @"http://earthquake-report.com/feeds/";

@implementation PBAQuakeStore

+ (PBAQuakeStore *)sharedStore
{
    static PBAQuakeStore *sharedStore = nil;
    static dispatch_once_t PBAOnceToken;
    dispatch_once(&PBAOnceToken, ^{
        sharedStore = [[PBAQuakeStore alloc] init];
    });
    return sharedStore;
}

- (void)downloadDataWithCompletion:(void (^)(NSArray *quakes, NSError *error))completion
{
//    if (YES) {
//        // cache < 24 hours old
//        // return cached data
//        NSArray *quakeData = nil; // retrieve data from CoreData
//        completion(quakeData,nil);
//    } else {
        NSMutableArray *quakeData = [NSMutableArray array];
        NSString *path = [NSString stringWithFormat:@"%@%@", PBAQuakeStoreBaseURLString, @"recent-eq?json"];
        NSURL *url = [NSURL URLWithString:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *sess = [NSURLSession sharedSession];
        NSURLSessionDataTask *task =
        [sess dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                              NSURLResponse *response,
                                                              NSError *error) {

            if (data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:&error];
                for (NSDictionary *d in json) {
                    PBAQuake *quake = [[PBAQuake alloc] init];
                    quake.location = [d objectForKey:@"location"];
                    quake.quakeTitle = [d objectForKey:@"title"];
                    quake.link = [d objectForKey:@"link"];
                    quake.depth = [[d objectForKey:@"depth"] doubleValue];
                    quake.magnitude = [[d objectForKey:@"magnitude"] doubleValue];
                    quake.latitude = [[d objectForKey:@"latitude"] floatValue];
                    quake.longitude = [[d objectForKey:@"longitude"] floatValue];
                    quake.dateTime = [d objectForKey:@"date_time"];

                    [quakeData addObject:quake];
                }

                if (completion) {
                    completion(quakeData, nil);
                }
            } else {
                if (completion) {
                    completion(nil, error);
                }
            }
        }];
        [task resume];
//    }
}

@end
