//
//  ShareCard.h
//  LoveScore
//
//  Created by Oleksandr on 12/17/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ShareCard : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *cardType;
@property (strong, nonatomic) NSArray *recipients;

@end
