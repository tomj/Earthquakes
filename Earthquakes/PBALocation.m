//
//  MyLocation.m
//
//  Created by Pouria Almassi on 4/10/12.
//  Copyright (c) 2012 All rights reserved.
//

#import "PBALocation.h"

@implementation PBALocation

- (instancetype)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate
{
	if ((self = [super init])) {
		_name = [name copy];
		_address = [address copy];
		_coordinate = coordinate;
	}
	return self;
}

- (NSString *)title
{
	if ([_name isKindOfClass:[NSNull class]]) {
		return @"Unknown";
	}
    else {
		return _name;
    }
}

- (NSString *)subtitle
{
	return _address;
}

@end
