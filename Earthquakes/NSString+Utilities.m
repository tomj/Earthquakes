//
//  NSString+Utilities.m
//  Earthquakes
//
//  Created by Pouria Almassi on 20160204.
//  Copyright © 2016 Pouria Almassi. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString *)trimWhitespace;
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
