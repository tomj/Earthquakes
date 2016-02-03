//
//  PBAPersistenceControllerTests.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160201.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PBAPersistenceController.h"

@interface PBAPersistenceControllerTests : XCTestCase

@property (nonatomic, strong) PBAPersistenceController *persistenceController;

@end

@implementation PBAPersistenceControllerTests

- (void)setUp {
    [super setUp];

    self.persistenceController = [[PBAPersistenceController alloc] initWithCallback:^{
        // no callback provided
    }];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPersistenceControllerIsNotNil
{
    XCTAssertNotNil(self.persistenceController, @"Persistence Controller is nil.");
}

- (void)testPersistenceControllerManagedObjectContextIsNotNil
{
    XCTAssertNotNil(self.persistenceController.managedObjectContext, @"Persistence Controller's MOC is nil.");
}

//- (void)testInitializeCoreData
//{
//
//}

//- (void)testSave
//{
//
//}

- (void)testObjectsFromEntity:(NSString *)entity;
{
    //
}

@end
