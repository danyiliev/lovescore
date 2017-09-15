//
//  Calendar.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 2/3/16.
//  Copyright © 2016 KindGeek. All rights reserved.
//

#import "Calendar.h"

@interface Calendar () <CalendarViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic)NSDateFormatter *dateFormatter;

@end

@implementation Calendar

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendarView.calendarDelegate = self;
    [self.calendarView setShouldShowHeaders:YES];
    [self.calendarView refresh];
    self.dateFormatter = [NSDateFormatter new];
    [self.dateFormatter setDateFormat:@"YYYY-MMMM"];
    NSDate *date = self.calendarView.currentDate;
    NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
    self.calendarView.fontSelectedColor = RED_COLOR;
    self.calendarView.fontName = @"Lato-Light";
    self.calendarView.fontColor = [UIColor darkGrayColor];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]]; ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextMonthTapped:(id)sender {
    [self.calendarView advanceCalendarContentsWithEvent:CalendarEventSwipeRight];
    NSDate *date = self.calendarView.currentDate;
    NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];
    
}
- (IBAction)previousMonthTapped:(id)sender {
    [self.calendarView advanceCalendarContentsWithEvent:CalendarEventSwipeLeft];
    NSDate *date = self.calendarView.currentDate;
    NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];

}
- (IBAction)nextYearTapped:(id)sender {
    [self.calendarView nextYear];
    NSDate *date = self.calendarView.currentDate;
    NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];

}

- (IBAction)previousYearTapped:(id)sender {
    [self.calendarView previousYear];
    NSDate *date = self.calendarView.currentDate;
    NSArray *components = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",components[1],components[0]];

}
#pragma mark - CalendarView delegate

- (void)didChangeCalendarDate:(NSDate *)date {
    if ([_delegate respondsToSelector:@selector(calendar:didSelectDate:)]) {
        [_delegate calendar:self didSelectDate:date];
    }
}

@end
