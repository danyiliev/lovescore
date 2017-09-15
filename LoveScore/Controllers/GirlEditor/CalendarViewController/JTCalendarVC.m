//
//  JTCalendarVC.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 4/7/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "JTCalendarVC.h"

@interface JTCalendarVC () <JTCalendarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *menuView;
@property (weak, nonatomic) IBOutlet UIView *bordersView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation JTCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendarManager = [JTCalendarManager new];
    self.calendarManager.delegate = self;
    [self.calendarManager setMenuView:self.menuView];
    [self.calendarManager setContentView:self.calendarView];
    [self.calendarManager setDate:[NSDate date]];
    self.calendarView.layer.borderWidth = 0.5;
    self.calendarView.layer.borderColor = [UIColor whiteColor].CGColor;
    NSDate *date = self.calendarView.date;
    self.dateFormatter = [NSDateFormatter new];
    [self.dateFormatter setDateFormat:@"YYYY-MMMM"];
    NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]]; ;
    
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(UIView<JTCalendarDay> *)dayView {
    JTCalendarDayView *view = (JTCalendarDayView *)dayView;
    
    if ([calendar.dateHelper date:view.date isTheSameDayThan:[NSDate date]]) {
        view.textLabel.textColor = [UIColor whiteColor];
        view.backgroundColor = RED_COLOR;
    } else {
        view.textLabel.textColor = [UIColor colorWithRed:168/255.0f green:168/255.0f blue:168/255.0f alpha:1];
        view.backgroundColor = [UIColor whiteColor];
    }
    
    [view.textLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    NSString *day = view.textLabel.text;
    NSInteger intDay = [day integerValue];
    view.textLabel.text = [NSString stringWithFormat:@"%li",(long)intDay];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1].CGColor;

    if (view.isFromAnotherMonth) {
        view.textLabel.textColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
    }
    
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate *date = self.calendarView.date;
        NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];
        });
        
    });
}
- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate *date = self.calendarView.date;
        NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];
        });
        
    });
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView {
    JTCalendarDayView *view = (JTCalendarDayView *)dayView;
    view.textLabel.textColor = RED_COLOR;
    NSDate *date = dayView.date;
    if ([_delegate respondsToSelector:@selector(calendar:didSelectDate:)]) {
        [_delegate calendar:self didSelectDate:date];
    }
    
}
- (IBAction)previousYear:(id)sender {
    for (int i = 0; i < 12; i++) {
        [self.calendarManager.scrollManager.horizontalContentView loadPreviousPage];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate *date = self.calendarView.date;
        NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];
        });
        
    });
    [self.calendarManager reload];
}
- (IBAction)previousMonth:(id)sender {
    [self.calendarManager.scrollManager.horizontalContentView loadPreviousPage];
    NSDate *date = self.calendarView.date;
    NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];
    [self.calendarManager reload];
   }
- (IBAction)nextYear:(id)sender {
    for (int i = 0; i < 12; i++) {
        [self.calendarManager.scrollManager.horizontalContentView loadNextPage];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate *date = self.calendarView.date;
        NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];
        });
        
    });
    [self.calendarManager reload];


}
- (IBAction)nextMonth:(id)sender {
    [self.calendarManager.scrollManager.horizontalContentView loadNextPage];
    NSDate *date = self.calendarView.date;
    NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];
    [self.calendarManager reload];
}

@end
