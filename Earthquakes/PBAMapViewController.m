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
#import "UIColor+PBAColor.h"
#import "MyLocation.h"

@import CoreLocation;

@interface PBAMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) PBAWebService *webService;
@property (nonatomic) PBAPersistenceController *persistenceController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) UIButton *recenterMapToUserButton;
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
        self.tabBarItem.title = NSLocalizedString(@"mapviewcontroller.tabbaritem.title", @"The tab bar item title for the Map view.").capitalizedString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webService getObjectsWithCompletion:^(NSArray *objects, NSError *error) {
        [hud hide:YES];
        if (objects) {
            self.quakeData = objects;
            [self plotObjectsOnMap];
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

    [self setUpRecenterMapButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:@"pinLocation"];

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

- (void)recenterMapToUsersCurrentLocation
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

- (void)setUpRecenterMapButton
{
    UIButton *aButton = [[UIButton alloc] init];
    aButton.backgroundColor = [UIColor pba_blueColor];
    [aButton pba_setRoundedButtonStyle];
    [aButton addTarget:self action:@selector(recenterMapToUsersCurrentLocation)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    aButton.translatesAutoresizingMaskIntoConstraints = NO;
    id bottomGuide = self.bottomLayoutGuide;

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(aButton, bottomGuide);

    NSArray *wConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[aButton(50)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];

    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[aButton(50)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];

    NSArray *xConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[aButton]-10-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];

    NSArray *yConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[aButton]-[bottomGuide]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];

    [self.view addConstraints:wConstraints];
    [self.view addConstraints:hConstraints];
    [self.view addConstraints:xConstraints];
    [self.view addConstraints:yConstraints];
    [self.view layoutSubviews];
    
    self.recenterMapToUserButton = aButton;
}

@end
