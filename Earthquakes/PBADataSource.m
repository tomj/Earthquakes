//
//  PBADataSource.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160129.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "PBADataSource.h"
#import "Quake.h"

@interface PBADataSource ()

@property (nonatomic, copy) NSArray *objects;

@end

@implementation PBADataSource

- (instancetype)initWithObjects:(NSArray *)objects;
{
    self = [super init];
    if (self) {
        _objects = objects;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects ? self.objects.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TempCell" forIndexPath:indexPath];

    Quake *q = [self.objects objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ / %@", q.location, q.magnitude];

    return cell;
}

@end
