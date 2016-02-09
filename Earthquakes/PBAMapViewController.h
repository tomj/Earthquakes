//
//  PBAMapViewController.h
//  Earthquakes
//
//  Created by Pouria Almassi on 2/5/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBAWebService;
@class PBAPersistenceController;

@interface PBAMapViewController : UIViewController

- (instancetype)initWithWebService:(PBAWebService *)webService persistenceController:(PBAPersistenceController *)persistenceController;

@end
