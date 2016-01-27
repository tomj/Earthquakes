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

// Store
#import "PBAQuakeStore.h"

// Model
#import "PBAQuake.h"
#import "MyLocation.h"

// Categories
#import "UIButton+PBAButton.h"

@import CoreLocation;

@interface PBAMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *recenterMapToUserButton;
@property (strong, nonatomic) NSArray *quakeData;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PBAMapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Map";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.recenterMapToUserButton pba_setRoundedButtonStyle];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[PBAQuakeStore sharedStore] downloadDataWithCompletion:^(NSArray *quakes, NSError *error) {
        [hud hide:YES];
        if (!error) {
            self.quakeData = quakes;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self plotQuakeData];
            });
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error performing the request. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
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

    [self recenterMapToUsersCurrentLocationAfterDelay:5.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
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

- (void)plotQuakeData
{
    for (PBAQuake *q in self.quakeData) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = q.latitude;
        coordinate.longitude  = q.longitude;
        NSString *location = q.location;
        NSString *magnitude = [NSString stringWithFormat:@"Magnitude: %g", q.magnitude];

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
