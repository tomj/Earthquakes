//
//  PBALocationTests.m
//  Earthquakes
//
//  Created by Pouria Almassi on 3/17/16.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PBALocation.h"

@interface PBALocationTests : XCTestCase

@property (nonatomic) PBALocation *location;

@end

@implementation PBALocationTests

- (void)setUp {
    [super setUp];

    CLLocationDegrees lat = 1.00000000;
    CLLocationDegrees lon = 1.00000000;
    CLLocation *c = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    self.location = [[PBALocation alloc] initWithName:@"" address:@"" coordinate:c.coordinate];
}

- (void)tearDown {
    [super tearDown];

    self.location = nil;
}

- (void)testNotNil {
    XCTAssertNotNil(self.location, @"PBALocation object is nil.");
}

@end
