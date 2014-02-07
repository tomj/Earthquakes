//
//  PBAQuake.h
//  Earthquakes
//
//  Created by Pouria Almassi on 2/6/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBAQuake : NSObject

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *quakeTitle;
@property (nonatomic) double depth;
@property (nonatomic) double magnitude;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@property (nonatomic) NSDate *dateTime;

@end
