//
//  StarRatingView.m
//  LoveScore
//
//  Created by Marcin Podeszwa on 7/4/17.
//  Copyright © 2017 KindGeek. All rights reserved.
//

#import "StarRatingView.h"
#import "UIColor+ColorAdditions.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface StarRatingView ()

@property (nonatomic, strong) HCSStarRatingView *ratingView;

@end

@implementation StarRatingView

- (instancetype)init {
    if (self = [super init]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.backgroundColor = [UIColor clearColor];
    CGSize size = [[self class] size];
    _ratingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _ratingView.maximumValue = 5;
    _ratingView.backgroundColor = [UIColor clearColor];
    _ratingView.minimumValue = 0;
    _ratingView.value = 2.5;
    _ratingView.spacing = 1.0;
    _ratingView.allowsHalfStars = true;
    _ratingView.continuous = false;
    _ratingView.accurateHalfStars = false;
    _ratingView.tintColor = [UIColor redLoveScoreColor];
    _ratingView.userInteractionEnabled = false;
    _ratingView.emptyStarImage = [UIImage imageNamed:@"girl-rating-empty-star"];
    _ratingView.filledStarImage = [UIImage imageNamed:@"girl-rating-star"];
    [self addSubview:_ratingView];
}

- (void)setValue:(float)value {
    [_ratingView setValue:value / 2.0f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _ratingView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    _ratingView.tintColor = tintColor;
}

+ (CGSize)size {
    return CGSizeMake(44, 8);
}

@end
