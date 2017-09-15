//
//  ShareCard.m
//  LoveScore
//
//  Created by Oleksandr on 12/17/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "ShareCard.h"

@implementation ShareCard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uuid" : @"uuid",
             @"cardType" : @"card_type",
             @"recipients" : @"recipients"
             };
}

@end
