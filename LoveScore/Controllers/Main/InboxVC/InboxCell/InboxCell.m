//
//  InboxCell.m
//  LoveScore
//
//  Created by Roman Sakhnievych on 11/3/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import "InboxCell.h"
#import "RoundRateView.h"
#import "CoreDataManager.h"


@interface InboxCell ()

@property (strong, nonatomic) IBOutlet UIImageView *stateImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *sendTimeLabel;

@property (strong, nonatomic) IBOutlet RoundRateView *roundRateView;
@property (strong, nonatomic) IBOutlet UIImageView *flagImageView;
@property (strong, nonatomic)NSDictionary *countriesDictionary;
@end

@implementation InboxCell

#pragma mark - Sustem and inits methods

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.roundRateView setFontName:@"Lato-Regular" size:12.f];
    self.countriesDictionary = [[CoreDataManager instance] getCountriesDictionaryFromDataBase];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public methods

- (NSString *)getStateImageNameWithType:(NSString *)type status:(NSString *)status {
    NSString *imageName;
    if ([type isEqualToString:@"incoming"] && [status isEqualToString:@"SNT"]) {
        imageName = @"lovebox-icon-heart-full";
    }
    if ([type isEqualToString:@"incoming"] && [status isEqualToString:@"RCV"]) {
        imageName = @"edit-icons-heart";
    }
    if ([type isEqualToString:@"outgoing"] && [status isEqualToString:@"SNT"]) {
        imageName = @"lovebox-icon-arrow-full";
    }
    if ([type isEqualToString:@"outgoing"] && [status isEqualToString:@"RCV"]) {
        imageName = @"lovebox-icon-arrow-empty";
    }
    return imageName;
}

- (void)setRetrieveInboxModel:(RetrieveInbox *)retrieveModel {
    self.nameLabel.text = [retrieveModel.relatedUser objectForKey:@"username"];
    [self.stateImageView setImage:[UIImage imageNamed:[self getStateImageNameWithType:retrieveModel.type status:retrieveModel.status]]];
    [self.roundRateView setRoundRateViewValue:retrieveModel.rating];
    self.sendTimeLabel.text = [self titleByDateString:retrieveModel.createdAt];
    [self.flagImageView setImage:[UIImage imageNamed:retrieveModel.nationality]];
}

- (NSString *)titleByDateString:(NSString *)dateString {
    NSString *title;
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *notDate = [formater dateFromString:dateString];
    NSDate *date = [self getCurrentTimeZoneDateAndTimeFromDate:notDate];
    NSDate *nowDate = [self getCurrentTimeZoneDateAndTimeFromDate:[NSDate date]];
    NSDateComponents *conversionInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:date toDate:nowDate options:0];
    NSInteger minutes = [conversionInfo minute];
    NSInteger hours = [conversionInfo hour];
    NSInteger days = [conversionInfo day];

    if (minutes <= 1) {
        title = @"Just now";
    } else if (minutes > 1) {
        title = [NSString stringWithFormat:@"%li minutes ago",(long)minutes];
    }
    
    if (hours == 1) {
        title = [NSString stringWithFormat:@"%li hour ago",(long)hours];
    } else if (hours > 1) {
        title = [NSString stringWithFormat:@"%li hours ago",(long)hours];
    }
    
    if (days == 1) {
        title = [NSString stringWithFormat:@"%li day ago",(long)days];
    }
    if (days > 1) {
        [formater setDateFormat:@"dd MMMM YYYY HH:mm"];
        title = [formater stringFromDate:date];
    }
    
    return title;
}

- (NSDate *)getCurrentTimeZoneDateAndTimeFromDate:(NSDate *)date {
    NSDate* currentDate = date;
    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    NSDate* nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    return nowDate;
}

@end
