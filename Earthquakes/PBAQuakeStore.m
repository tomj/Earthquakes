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

- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

/*
 {
 "date_time" = "2014-02-05T12:26:37+00:00";
 depth = 198;
 latitude = "-21.21";
 link = "http://earthquake-report.com/2014/02/05/moderate-earthquake-potosi-bolivia-on-february-5-2014/";
 location = "POTOSI, BOLIVIA";
 longitude = "-67.99";
 magnitude = "4.2";
 title = "Moderate earthquake - Potosi, Bolivia on February 5, 2014";
 }
 */


- (void)downloadDataWithCompletion:(void (^)(NSArray *quakes, NSError *error))completion
{
    NSMutableArray *quakeData = [NSMutableArray array];

    //Returns a shared singleton session object. The shared session uses the currently set
    //global NSURLCache, NSHTTPCookieStorage, and NSURLCredentialStorage objects and is based on the default configuration.
    NSURLSession *sess = [NSURLSession sharedSession];

    //reuse base url
    NSString *path = [NSString stringWithFormat:@"%@%@", PBAQuakeStoreBaseURLString, @"recent-eq?json"];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //create a data (download) task
    NSURLSessionDataTask *task = [sess dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!error)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

            for (NSDictionary *d in json)
            {
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

            // TODO
            if (completion) {
                completion(quakeData, nil);
            }
        }
        else
        {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
    [task resume];
}

@end
