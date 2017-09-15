//
//  ExtededView.h
//  LoveScore
//
//  Created by Oleksandr Shymanskyi on 10/29/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
In a case of storyboards error you should update cocapods.
 Just enter:
 [sudo] gem install cocoapods --pre
 */

IB_DESIGNABLE
@interface ExtededView : UIView

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;

@end
