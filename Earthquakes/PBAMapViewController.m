//
//  PBAMapViewController.m
//  Earthquakes
//
//  Created by Pouria Almassi on 2/5/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

@import MapKit;
@import CoreLocation;
@import QuartzCore;

#import "PBAMapViewController.h"
#import "MBProgressHUD.h"
#import "PBAWebService.h"
#import "PBAPersistenceController.h"
#import "Quake.h"
#import "UIButton+PBAButton.h"
#import "MyLocation.h"

@import CoreLocation;

@interface PBAMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) PBAWebService *webService;
@property (nonatomic) PBAPersistenceController *persistenceController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *recenterMapToUserButton;
@property (nonatomic, copy) NSArray *quakeData;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PBAMapViewController

- (instancetype)initWithWebService:(PBAWebService *)webService persistenceController:(PBAPersistenceController *)persistenceController;
{
    self = [super init];
    if (self) {
        _webService = webService;
        _persistenceController = persistenceController;

        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.tabBarItem.title = @"Map";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.recenterMapToUserButton pba_setRoundedButtonStyle];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.webService getObjectsWithCompletion:^(NSArray *objects, NSError *error) {
        [hud hide:YES];
        if (objects) {
            self.quakeData = objects;

            [self plotObjectsOnMap];
        } else {
            NSLog(@"Womp. Error: %@", error.localizedDescription);
        }
    }];

    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }

    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1;

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = NO;

    [self recenterMapToUsersCurrentLocationAfterDelay:10.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinLocation"];

    if (annotation == self.mapView.userLocation) {
        return nil;
    }

    newAnnotation.pinColor = MKPinAnnotationColorRed;
    newAnnotation.canShowCallout = YES;

    return newAnnotation;
}

#pragma mark - Custom methods

- (void)plotObjectsOnMap
{
    for (Quake *q in self.quakeData) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [q.latitude doubleValue];
        coordinate.longitude  = [q.longitude doubleValue] ;
        NSString *location = q.location;
        NSString *magnitude = [NSString stringWithFormat:@"Magnitude: %@", q.magnitude];

        MyLocation *annotation = [[MyLocation alloc]
                                  initWithName:location
                                  address:magnitude
                                  coordinate:coordinate];

        [self.mapView addAnnotation:annotation];
    }
}

- (IBAction)recenterMapToUsersCurrentLocation
{
    [self recenterMapToUsersCurrentLocationAfterDelay:0.0];
}

- (void)recenterMapToUsersCurrentLocationAfterDelay:(double)delay {
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.mapView.centerCoordinate = strongSelf.mapView.userLocation.coordinate;
    });
}

@end
