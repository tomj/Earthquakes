//
//  PBAAppDelegate.m
//  Earthquakes
//
//  Created by Pouria Almassi on 2/5/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import "PBAAppDelegate.h"
#import "PBAMapViewController.h"
#import "PBAListViewController.h"
#import "PBAPersistenceController.h"
#import "PBAWebService.h"

@interface PBAAppDelegate ()

@property (strong, readwrite) PBAPersistenceController *persistenceController;

- (void)completeUserInterfaceSetup;

@end

@implementation PBAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setPersistenceController:[[PBAPersistenceController alloc] initWithCallback:^{
        [self completeUserInterfaceSetup];
    }]];

    // application.statusBarStyle = UIStatusBarStyleLightContent;

    return YES;
}

- (void)completeUserInterfaceSetup;
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    PBAWebService *webService = [[PBAWebService alloc] init];
    webService.persistenceController = self.persistenceController;
    PBAMapViewController *mvc = [[PBAMapViewController alloc] initWithWebService:webService
                                                           persistenceController:self.persistenceController];
    PBAListViewController *lvc = [[PBAListViewController alloc] initWithWebService:webService
                                                             persistenceController:self.persistenceController];

    UINavigationController *mnc = [[UINavigationController alloc] initWithRootViewController:mvc];
    UINavigationController *lnc = [[UINavigationController alloc] initWithRootViewController:lvc];

    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.viewControllers = @[mnc, lnc];

    self.window.rootViewController = tbc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

}

- (void)setStyle
{
    UIColor *blahColor = [UIColor colorWithRed:0.0 green:0.502 blue:0.0 alpha:1.0];
    [UINavigationBar appearance].barTintColor = blahColor;
    [UINavigationBar appearance].tintColor = blahColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [UITabBar appearance].barTintColor = blahColor;
    [UITabBar appearance].tintColor = blahColor;
}

// Sent when the application is about to move from active to inactive state.
// This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
// or when the user quits the application and it begins the transition to the background state.
// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
// Games should use this method to pause the game.
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.persistenceController save];
}

// Use this method to release shared resources, save user data, invalidate timers, and store enough application
// state information to restore your application to its current state in case it is terminated later.
// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.persistenceController save];
}

// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.persistenceController save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.
}


@end
