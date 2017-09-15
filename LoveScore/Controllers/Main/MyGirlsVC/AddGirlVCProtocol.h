//
//  AddGirlVCProtocol.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 12/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddGirlVCProtocol <NSObject>

@property (nonatomic, strong) NSMutableArray *girls;
@property (nonatomic, strong) NSString *titleString;
- (void)refresh;

@end
