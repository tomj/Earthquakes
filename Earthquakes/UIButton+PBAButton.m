//
//  UIButton+PBAButton.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160127.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "UIButton+PBAButton.h"

@implementation UIButton (PBAButton)

- (void)pba_setRoundedButtonStyle;
{
    self.layer.cornerRadius = 45.0 / 2.0;
    self.alpha = 0.9;
}

@end
