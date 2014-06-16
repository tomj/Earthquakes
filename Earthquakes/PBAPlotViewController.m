//
//  PBAPlotViewController.m
//  Earthquakes
//
//  Created by Pouria Almassi on 2/9/14.
//  Copyright (c) 2014 Pouria Almassi. All rights reserved.
//

#import "PBAPlotViewController.h"

@interface PBAPlotViewController ()

@end

@implementation PBAPlotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Graph";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
