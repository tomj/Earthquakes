//
//  PBAMapViewController.m
//  Earthquakes
//
//  Created by Pouria Almassi on 2/5/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

//
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#import "PBAMapViewController.h"
#import "MBProgressHUD.h"

// Store
#import "PBAQuakeStore.h"

// Model
#import "PBAQuake.h"
#import "MyLocation.h"

@import CoreLocation;

@interface PBAMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *quakeData;

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

    // progress indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // make network request call through the store
    [[PBAQuakeStore sharedStore] downloadDataWithCompletion:^(NSArray *quakes, NSError *error) {
        
        [hud hide:YES];
        
        if (!error) {
            self.quakeData = quakes;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self plotQuakeData];
            });
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"There was an error performing the request. Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    // map view
    self.mapView.delegate = self;
	self.mapView.showsUserLocation = YES;
    
    // core location
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = 2;
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// similar to tableView:cellForRowAtIndexPath:
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
	MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinLocation"];
    
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
	newAnnotation.pinColor = MKPinAnnotationColorRed;
	newAnnotation.canShowCallout = YES;
	newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
	return newAnnotation;
}

#pragma mark - Core Location

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%f, %f", self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude);
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

@end
