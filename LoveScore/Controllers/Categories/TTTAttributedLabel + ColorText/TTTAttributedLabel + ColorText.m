//
//  TTTAttributedLabel + ColorText.m
//  LoveScore
//
//  Created by админ on 11/16/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "TTTAttributedLabel + ColorText.h"
#import "Global.h"

@implementation TTTAttributedLabel (ColorText)

+ (instancetype) getString: (NSString*)allString withRedWord: (NSString*)redWord {
    NSMutableAttributedString *newTittle = [[NSMutableAttributedString alloc] initWithString:allString];
    NSRange rangeOfRedText = [allString rangeOfString:redWord];
    NSRange fontRange = [allString rangeOfString:allString];
    [newTittle addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:rangeOfRedText];
    [newTittle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Lato-Medium" size:17] range:fontRange];
    
    TTTAttributedLabel * label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 600, 64)];
    [label setFont:[UIFont fontWithName:@"Lato-Regular" size:17]];
    label.attributedText = newTittle;
    [label sizeToFit];
    return label;
}
@end
