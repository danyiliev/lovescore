//
//  NavigationTitle.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/28/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface NavigationTitle : NSObject


+ (TTTAttributedLabel *) createMultiColorsLabelWithString:(NSString *)text font:(UIFont *)font colors:(NSArray*)colors;

@end
