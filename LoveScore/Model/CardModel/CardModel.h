//
//  CardModel.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 12/21/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CardModel : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic)NSString *ident;
@property (strong, nonatomic)NSString *cardType;
@property (strong, nonatomic)NSDictionary *friendDic;
@property (strong, nonatomic)NSDictionary *person; 

@end
