//
//  MyLocation.m
//
//  Created by Pouria Almassi on 4/10/12.
//  Copyright (c) 2012 All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject <MKAnnotation>

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;

// TODO can you just init this with an instance of your model?
-(instancetype)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
