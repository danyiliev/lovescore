//
//  CalendarVC.h
//  LoveScore
//
//  Created by Roman Sakhnievych on 2/1/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
@class CalendarVC;

@protocol CalendarVCDelegate <NSObject>
- (void)calendarVC:(CalendarVC *)calendarVC didSelectDate:(NSDate *)date;
@end

@interface CalendarVC : UIViewController
@property (weak, nonatomic)id <CalendarVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *menuView;
@property (strong, nonatomic) NSDate *dateSelected;


@end
