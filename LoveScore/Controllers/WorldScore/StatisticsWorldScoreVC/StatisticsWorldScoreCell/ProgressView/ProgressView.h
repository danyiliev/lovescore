//
//  ProgressView.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 10/27/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property(nonatomic, strong)UIView *progress;
@property(nonatomic, strong)UILabel *lable;
@property(nonatomic)NSInteger percents;
@property(nonatomic)CGFloat progressValue;

- (void)setProgressWithPercent:(NSInteger)percents;

@end
