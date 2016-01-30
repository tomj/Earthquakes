//
//  PBAAppDelegate.h
//  Earthquakes
//
//  Created by Pouria Almassi on 2/5/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBAPersistenceController;

@interface PBAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
// only app delegate has right to destry this object
@property (strong, readonly) PBAPersistenceController *persistenceController;

@end
