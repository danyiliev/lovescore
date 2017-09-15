//
//  Calendar.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 2/3/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarView.h"

@class Calendar;

@protocol CalendarDelegate <NSObject>
- (void)calendar:(Calendar *)calendar didSelectDate:(NSDate *)date;
@end


@interface Calendar : UIViewController

@property (weak, nonatomic)id <CalendarDelegate> delegate;
@property (strong, nonatomic) IBOutlet  CalendarView *calendarView;

@end
