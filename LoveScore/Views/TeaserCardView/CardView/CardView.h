//
//  CardView.h
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardViewDelegate <NSObject>

- (void)cardViewWasTapped;

@end

@interface CardView : UIView

@property (nonatomic, weak) id<CardViewDelegate> delegate;

@end
