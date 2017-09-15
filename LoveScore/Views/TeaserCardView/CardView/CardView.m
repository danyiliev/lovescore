//
//  CardView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "CardView.h"

@interface CardView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {

    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // Corner Radius
    self.layer.cornerRadius = 7.0;
    
    //GR
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];

    [self addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Private methods

- (void)tapOnView:(UITapGestureRecognizer *)tapGesture {
    if ([_delegate respondsToSelector:@selector(cardViewWasTapped)]) {
        [_delegate cardViewWasTapped];
    }
}

@end
