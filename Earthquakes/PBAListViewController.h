//
//  PBAListViewController.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160131.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBAWebService;
@class PBAPersistenceController;

@interface PBAListViewController : UIViewController

- (instancetype)initWithWebService:(PBAWebService *)webService
             persistenceController:(PBAPersistenceController *)persistenceController;

@end
