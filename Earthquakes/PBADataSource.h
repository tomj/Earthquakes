//
//  PBADataSource.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160129.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBADataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithObjects:(NSArray *)objects;

@end
