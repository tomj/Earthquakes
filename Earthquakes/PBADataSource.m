//
//  PBADataSource.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160129.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "PBADataSource.h"
#import "Quake.h"
#import "PBAListTableViewCell.h"

@interface PBADataSource ()

@property (nonatomic, copy) NSArray *objects;
@property (nonatomic, copy) NSString *identifier;

@end

@implementation PBADataSource

- (instancetype)initWithObjects:(NSArray *)objects
                     identifier:(NSString *)identifier;
{
    self = [super init];
    if (self) {
        _objects = objects;
        _identifier = identifier;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects ? self.objects.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBAListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];

    Quake *q = [self.objects objectAtIndex:indexPath.row];

    cell.locationLabel.text = q.location;
    cell.dateLabel.text = [[self dateFormatter] stringFromDate:q.dateTime];
    cell.magnitudeLabel.text = [NSString stringWithFormat:@"%@", q.magnitude];

    return cell;
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY MM dd";
    });
    return dateFormatter;
}

@end
