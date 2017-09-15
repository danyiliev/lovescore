//
//  StatisticsRateView.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/4/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#define SMALL_RATE_VIEW_Y 16.0f

#import "StatisticsRateView.h"
#import "RoundDoubleRateView.h"
#import "StarRatingView.h"
#import "Global.h"

@interface StatisticsRateView ()

@property (nonatomic, strong) RoundRateView *loveRateView;
@property (nonatomic, strong) RoundRateView *kissRateView;
@property (nonatomic, strong) RoundDoubleRateView *loveDoubleRateView;
@property (nonatomic, strong) RoundDoubleRateView *kissDoubleRateView;
@property (nonatomic, strong) StarRatingView *fullRateView;
@property (nonatomic, strong) UIImageView *lipsImageView;
@property (nonatomic, strong) UIImageView *heartImageView;

@end

@implementation StatisticsRateView {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    self.fullRateView = [StarRatingView new];
    self.kissRateView = [RoundRateView new];
    self.loveRateView = [RoundRateView new];
    self.kissDoubleRateView = [RoundDoubleRateView new];
    self.loveDoubleRateView = [RoundDoubleRateView new];
}

-(void)layoutSubviews {
    [self setupFullRateView];
    [self setupKissRateView];
    [self setupLoveRateView];
}

#pragma mark - Private methods

- (UIImageView *)lipsImageView {
    if (!_lipsImageView) {
        
        _lipsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui-list-icon-mouth"]];
        
        [self addSubview: _lipsImageView];
    }
    
    return _lipsImageView;
}

- (UIImageView *)heartImageView {
    if (!_heartImageView) {
        _heartImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui-list-icon-heart"]];
        
        [self addSubview:_heartImageView];
    }
    
    return _heartImageView;
}

- (void)setupFullRateView {
    CGSize size = [StarRatingView size];
    
    CGFloat x = (self.frame.size.width - size.width) - 8;
    CGFloat y = (self.frame.size.height / 2) - (size.height / 2);
    self.fullRateView.frame = CGRectMake(x, y, size.width, size.height);
    [self addSubview:self.fullRateView];
}

- (void)setupKissRateView {
    
    CGFloat lipsImageWidth = self.lipsImageView.frame.size.width;
    CGFloat lipsImageHeight = self.lipsImageView.frame.size.height;
    
    CGFloat lipsImageX = self.frame.size.width - self.fullRateView.frame.size.width - self.lipsImageView.frame.size.width - 36;
    CGFloat lipsImageY = (self.frame.size.height / 2) - (self.lipsImageView.frame.size.height / 2);
    
    self.lipsImageView.frame = CGRectMake(lipsImageX, lipsImageY, lipsImageWidth, lipsImageHeight);
    
    [self.kissRateView setBorderWidth:1];
    [self.kissRateView setBackgroundColor:LIGHT_GREY_COLOR];
    [self.kissDoubleRateView setBorderWidth:1];
    [self.kissDoubleRateView setBackgroundColor:LIGHT_GREY_COLOR];
    
    CGFloat kissViewWidth = 25;
    CGFloat kissViewHeight = 25;
    
    CGFloat kissViewX = lipsImageX + 30;
    CGFloat kissViewY = SMALL_RATE_VIEW_Y;
    
    self.kissRateView.frame = CGRectMake(kissViewX, kissViewY, kissViewWidth, kissViewHeight);
    [self.kissRateView setFontName:@"Lato-Regular" size:10];
    
    self.kissDoubleRateView.frame = CGRectMake(kissViewX, kissViewY, kissViewWidth, kissViewHeight);
    [self.kissDoubleRateView setFontName:@"Lato-Regular" size:10];
    
    [self addSubview:self.kissRateView];
    [self addSubview:self.kissDoubleRateView];
}

- (void)setupLoveRateView {
    
    CGFloat heartViewWidth = self.heartImageView.frame.size.width;
    CGFloat heartViewHeight = self.heartImageView.frame.size.height;
    
    CGFloat heartViewX = self.lipsImageView.frame.origin.x - heartViewWidth - 40;
    CGFloat heartViewY = (self.frame.size.height / 2) - (self.heartImageView.frame.size.height / 2);
    
    self.heartImageView.frame = CGRectMake(heartViewX, heartViewY, heartViewWidth, heartViewHeight);
    
    [self.loveRateView setBorderWidth:1];
    [self.loveRateView setBackgroundColor:LIGHT_GREY_COLOR];
    [self.loveDoubleRateView setBorderWidth:1];
    [self.loveDoubleRateView setBackgroundColor:LIGHT_GREY_COLOR];
    
    CGFloat loveViewWidth = 25;
    CGFloat loveViewHeight = 25;
    
    CGFloat loveViewX = heartViewX + 25;
    CGFloat loveViewY = SMALL_RATE_VIEW_Y;
    
    self.loveRateView.frame = CGRectMake(loveViewX, loveViewY, loveViewWidth, loveViewHeight);
    [self.loveRateView setFontName:@"Lato-Regular" size:10];
    self.loveDoubleRateView.frame = CGRectMake(loveViewX, loveViewY, loveViewWidth, loveViewHeight);
    [self.loveDoubleRateView setFontName:@"Lato-Regular" size:10];
    
    [self addSubview:self.loveRateView];
    [self addSubview:self.loveDoubleRateView];
}

- (void)setLoveRate:(NSNumber *)rate {
    self.loveDoubleRateView.hidden = true;
    if ([rate integerValue] == 0) {
        [self.loveRateView setHidden:YES];
    } else {
        [self.loveRateView setHidden:NO];
    }
    
    [self.loveRateView setValueWithString:[rate stringValue]];
}

- (void)setKissRate:(NSNumber *)rate {
    self.kissDoubleRateView.hidden = true;
    if ([rate integerValue] == 0) {
        [self.kissRateView setHidden:YES];
    } else {
        [self.kissRateView setHidden:NO];
    }
    
    [self.kissRateView setValueWithString:[rate stringValue]];
}

- (void)setLoveRate:(NSNumber *)rate inCountries:(NSInteger)countries {
    self.loveRateView.hidden = true;
    if ([rate integerValue] == 0) {
        [self.loveDoubleRateView setHidden:YES];
    } else {
        [self.loveDoubleRateView setHidden:NO];
    }

    [_loveDoubleRateView setValueWithString1:[NSString stringWithFormat:@"%ld", (long)countries] string2:[rate stringValue]];
}

- (void)setKissRate:(NSNumber *)rate inCountries:(NSInteger)countries {
    self.kissRateView.hidden = true;
    if ([rate integerValue] == 0) {
        [self.kissDoubleRateView setHidden:YES];
    } else {
        [self.kissDoubleRateView setHidden:NO];
    }

    [_kissDoubleRateView setValueWithString1:[NSString stringWithFormat:@"%ld", (long)countries] string2:[rate stringValue]];
}

- (void)setFullRate:(NSNumber *)rate {
    if (isnan([rate floatValue])) {
        [self.fullRateView setValue:0.0];
    } else {
        [self.fullRateView setValue:[rate floatValue]];
    }
}

@end
