//
//  PBAListTableViewCell.h
//  Earthquakes
//
//  Created by Pouria Almassi on 20160210.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBAListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnitudeLabel;

@end
