//
//  FullCheckInVCProtocol.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 1/14/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@protocol FullCheckInVCProtocol <NSObject>

@property (nonatomic, strong) Person *person;

@end
