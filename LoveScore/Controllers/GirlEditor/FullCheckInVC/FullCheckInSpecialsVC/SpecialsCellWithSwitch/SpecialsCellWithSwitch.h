//
//  SpecialsCellWithSwitch.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/30/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//


#define SpecialsCellWithSwitchId @"SpecialsCellWithSwitchId"

#import <UIKit/UIKit.h>

@protocol SpecialsCellWithSwitchDelegate <NSObject>

- (void)switchWasTurnOn:(NSString *)parameterName;
- (void)switchWasTurnOff:(NSString *)parameterName;

@end

@interface SpecialsCellWithSwitch : UITableViewCell

@property (nonatomic, strong) NSString *parameterName;
@property (nonatomic, weak) id<SpecialsCellWithSwitchDelegate> delegate;
@property (nonatomic) BOOL isSwitchTurnOn;

@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *name;

@end
