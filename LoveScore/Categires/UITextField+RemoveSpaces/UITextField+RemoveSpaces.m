//
//  UITextField+RemoveSpaces.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/26/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "UITextField+RemoveSpaces.h"

@implementation UITextField (RemoveSpaces)

- (void)removeSpacesFromString {

    NSMutableString *string = [self.text mutableCopy];
    if (![string isEqualToString:@""]){
    while([string characterAtIndex:0] == ' ') {
        
        [string replaceOccurrencesOfString:@" "
                                withString:@""
                                   options:0
                                     range:NSMakeRange(0, 1)];
        if (string.length == 0) {
            break;
        }

        
    }
    
    while([string characterAtIndex:string.length - 1] == ' ') {
        [string replaceOccurrencesOfString:@" "
                                withString:@""
                                   options:0
                                     range:NSMakeRange(string.length - 1, 1)];
    }
    
    while ([string containsString:@"  "]) {
        [string replaceOccurrencesOfString:@"  " withString:@" " options:0 range:NSMakeRange(0, string.length)];
    }
    }
    [self setText:string];
}

@end
