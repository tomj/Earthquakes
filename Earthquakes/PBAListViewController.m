//
//  PBAListViewController.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160131.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "PBAListViewController.h"
#import "PBAWebService.h"
#import "PBAPersistenceController.h"
#import "MBProgressHUD.h"
#import "PBADataSource.h"

@interface PBAListViewController ()

@property (nonatomic) PBAWebService *webService;
@property (nonatomic) PBAPersistenceController *persistenceController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PBADataSource *dataSource;

@end

@implementation PBAListViewController

- (instancetype)initWithWebService:(PBAWebService *)webService
             persistenceController:(PBAPersistenceController *)persistenceController;
{
    self = [super init];
    if (self) {
        _webService = webService;
        _persistenceController = persistenceController;

        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.tabBarItem.title = @"List";        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TempCell"];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    __weak __typeof (self)weakSelf = self;
    [self.webService getObjectsWithCompletion:^(NSArray *objects, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [hud hide:YES];
        if (objects) {
            strongSelf.dataSource = [[PBADataSource alloc] initWithObjects:objects];
            strongSelf.tableView.dataSource = strongSelf.dataSource;

            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
