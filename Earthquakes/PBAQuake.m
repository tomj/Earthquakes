//
//  PBAQuake.m
//  Earthquakes
//
//  Created by Pouria Almassi on 2/6/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import "PBAQuake.h"

// response data
//    {
//        "date_time" = "2014-02-05T12:26:37+00:00";
//        depth = 198;
//        latitude = "-21.21";
//        link = "http://earthquake-report.com/2014/02/05/moderate-earthquake-potosi-bolivia-on-february-5-2014/";
//        location = "POTOSI, BOLIVIA";
//        longitude = "-67.99";
//        magnitude = "4.2";
//        title = "Moderate earthquake - Potosi, Bolivia on February 5, 2014";
//    }

@implementation PBAQuake

- (NSString *)description
{
    NSString *descr = [NSString stringWithFormat:@"%@ / %@ / %@ / %g / %g / %f / %f / %@",
                       self.location,
                       self.link,
                       self.quakeTitle,
                       self.depth,
                       self.magnitude,
                       self.latitude,
                       self.longitude,
                       self.dateTime];
    return descr;
}

@end
