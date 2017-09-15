//
//  NSMutableAttributedString+ColorfulText.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/19/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "NSMutableAttributedString+ColorfulText.h"

@implementation NSMutableAttributedString (ColorfulText)

-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color
{
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

@end
