//
//  TTFormatter.m
//  LoveScore
//
//  Created by Timur Umayev on 4/27/16.
//  Copyright © 2016 Rarefields. All rights reserved.
//

#import "TTFormatter.h"

@implementation TTFormatter

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"YYYY-MM-dd"];
    });
    
    return formatter;
}

@end
