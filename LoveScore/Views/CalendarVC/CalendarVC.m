//
//  CalendarVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 2/1/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "CalendarVC.h"
#import "WYPopoverController.h"
#import "Global.h"

@interface CalendarVC () <JTCalendarDelegate>

@property (strong, nonatomic) JTCalendarManager * calendarManager;
- (IBAction)okTapped:(id)sender;


@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    self.dateSelected = [NSDate date];
    
    // Generate random events sort by date using a dateformatter for the demonstration
//    [self createRandomEvents];
//    
//    // Create a min and max date for limit the calendar, optional
//    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:self.menuView];
    [_calendarManager setContentView:self.calendarView];
    [_calendarManager setDate:[NSDate date]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
//    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
//        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = [UIColor blueColor];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
//    }
    // Selected date
     if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = RED_COLOR;
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    else if(![self.calendarManager.dateHelper date:self.calendarView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:self.calendarView.date isTheSameMonthThan:dayView.date]){
        if([self.calendarView.date compare:dayView.date] == NSOrderedAscending){
            [self.calendarView loadNextPageWithAnimation];
        }
        else{
            [self.calendarView loadPreviousPageWithAnimation];
        }
    }
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UIView *)menuItemView date:(NSDate *)date {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MMMM"];
    NSString *dateString = [formater stringFromDate:date];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSString *yearStr = dateArray[0];
    NSString *monthStr = dateArray[1];
    UILabel *label = (UILabel *)menuItemView;
    [label setText:[NSString stringWithFormat:@"%@ (%@)",monthStr,yearStr]];
}

- (IBAction)okTapped:(id)sender {
    if ([_delegate respondsToSelector:@selector(calendarVC:didSelectDate:)]) {
        [_delegate calendarVC:self didSelectDate:self.dateSelected];
    }
}

@end
