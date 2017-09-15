//
//  ActionDateView.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/7/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ActionDateView.h"

@implementation ActionDateView

- (void)setDate:(NSDate *)date {
    [self.dateLable setText:[[TTFormatter dateFormatter] stringFromDate:date]];
}

@end
