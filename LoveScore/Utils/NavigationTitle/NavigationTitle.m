//
//  NavigationTitle.m
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/28/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "NavigationTitle.h"

@implementation NavigationTitle


+ (TTTAttributedLabel *) createMultiColorsLabelWithString:(NSString *)text font:(UIFont *)font colors:(NSArray*)colors {
    
    if (!text || text.length == 0) {
        return nil;
    }
    
    if (!font) {
        // Default font
        font = [UIFont fontWithName:@"Lato-Medium" size:17];
    }
    if (!colors || colors.count == 0) {
        // Default colors
        colors = @[[UIColor colorWithRed:217.f / 255.f green:49.f / 255.f blue:49.f / 255.f alpha:1.0], [UIColor  colorWithRed:52.f / 255.f green:52.f / 255.f blue:52.f / 255.f alpha:1.0]];
    }
    
    NSArray *words = [text componentsSeparatedByString:@" "];
    
    if (words.count != colors.count) {
        NSLog(@"Number of words is not equal to number of colors");
        return nil;
    }
    
    NSMutableString *mutableText = [NSMutableString stringWithString:text];
    // Remove white space chars
//    [mutableText replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableText.length)];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:mutableText];
    
    NSRange range = NSMakeRange(0, string.length);
    [string addAttribute:NSFontAttributeName value:font range:range];
    
    int startLoc = 0;
    
    for (int i = 0; i < words.count; i++) {
        NSString *word = words[i];
        range = NSMakeRange(startLoc, word.length);
        [string addAttribute:NSForegroundColorAttributeName value:colors[i] range:range];
        startLoc = startLoc + (int)word.length;
    }
    
    TTTAttributedLabel * label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 30, 150)];
    label.attributedText = string;
    
    return label;
}



@end
