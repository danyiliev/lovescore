//
//  ExtendedImageView.h
//  LoveScore
//
//  Created by Timur Umayev on 4/27/16.
//  Copyright © 2016 Rarefields. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ExtendedImageView : UIImageView

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;

@end
