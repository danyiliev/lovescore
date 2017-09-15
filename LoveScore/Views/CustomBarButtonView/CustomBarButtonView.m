//
//  CustomBarButtonView.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/5/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "CustomBarButtonView.h"
#import "RoundRateView.h"
@interface CustomBarButtonView()

@property (weak, nonatomic) IBOutlet RoundRateView *requestNamber;
@property (weak, nonatomic) IBOutlet UILabel *requestsCountLabel;
@end

@implementation CustomBarButtonView

- (void)setRequestsCount:(NSInteger)count {
    [self.requestNamber setFontName:@"Lato-Regular" size:9];
    [self.requestNamber setValueWithString:[NSString stringWithFormat:@"%li",(long)count]];
}

@end
