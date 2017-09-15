//
//  JTCalendarVC.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/7/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@class JTCalendarVC;

@protocol JTCalendarVCDelegate <NSObject>
- (void)calendar:(JTCalendarVC *)calendar didSelectDate:(NSDate *)date;
@end

@interface JTCalendarVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarView;
@property (weak, nonatomic)id <JTCalendarVCDelegate> delegate;

@end
