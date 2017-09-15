//
//  WorldScoreProtocol.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/12/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStore.h"

@protocol WorldScoreProtocol <NSObject>

@property (nonatomic, strong)NSArray *girls;
@property (nonatomic, strong)DataStore *dataStore;

@end
