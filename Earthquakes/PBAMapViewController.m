//
//  PBAMapViewController.m
//  Earthquakes
//
//  Created by Pouria Almassi on 2/5/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import "PBAMapViewController.h"
#import "MBProgressHUD.h"

// Store
#import "PBAQuakeStore.h"

// Model
#import "PBAQuake.h"
#import "MyLocation.h"

@interface PBAMapViewController ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *quakeData;

@end

@implementation PBAMapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        self.tabBarItem.title = @"Map";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
	MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinLocation"];
    
	newAnnotation.pinColor = MKPinAnnotationColorRed;
	newAnnotation.canShowCallout = YES;
	//newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	
	return newAnnotation;
}

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
