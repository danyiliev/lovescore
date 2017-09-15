//
//  ExtendedButton.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/29/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ExtendedButton : UIButton

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) BOOL isSelected;

@end
