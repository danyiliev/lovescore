//
//  CardModel.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 12/21/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "CardModel.h"
#import "Person.h"

@implementation CardModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"ident" : @"ident",
             @"cardType" : @"card_type",
             @"friendDic" : @"friend",
             @"person" : @"person"
             };
}

@end
