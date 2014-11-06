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
    NSMutableArray *quakeData = [NSMutableArray array];
    
    // step 1: define path
    NSString *path = [NSString stringWithFormat:@"%@%@", PBAQuakeStoreBaseURLString, @"recent-eq?json"];
    
    // step 2: create instance of NSURLRequest
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // step 3: get instance of NSURLSession
    //
    // returns a shared singleton session object.
    // The shared session uses the currently set
    // global NSURLCache, NSHTTPCookieStorage,
    // and NSURLCredentialStorage objects and is based
    // on the default configuration.
    NSURLSession *sess = [NSURLSession sharedSession];
    
    // step 4: create a data (download) task
    NSURLSessionDataTask *task =
    [sess dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                          NSURLResponse *response,
                                                          NSError *error) {
        
        if (!error) {
            // step 6: serialize JSON data from the NSData object returned
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&error];
            
            // step 7: do stuff with retrieved JSON
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
        }
        else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
    
    // step 5: session tasks begin in the suspended state. we must resume them
    [task resume];
}

@end
