//
// Created by Maxim Pervushin on 28/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import "NSDate+HTLTimeHelpers.h"

NSString *htlStringWithTimeInterval(NSTimeInterval timeInterval) {
    NSInteger ti = (NSInteger) timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);

    return [NSString stringWithFormat:NSLocalizedString(@"%02ld:%02ld:%02ld", @"Duration string format"),
                                      (long) hours, (long) minutes, (long) seconds];
}

@implementation NSDate (HTLTimeHelpers)

+ (NSDateFormatter *)mediumFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.timeZone = [NSTimeZone localTimeZone];
    });
    return formatter;
}

+ (NSDateFormatter *)dateOnlyMediumFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        formatter.timeZone = [NSTimeZone localTimeZone];
    });
    return formatter;
}

+ (NSDateFormatter *)timeOnlyShortFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterNoStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        formatter.timeZone = [NSTimeZone localTimeZone];
    });
    return formatter;
}

+ (NSString *)stringWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSInteger startDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:startDate];
    NSInteger endDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:endDate];
    if (startDay == endDay) {
        return [NSString stringWithFormat:@"%@, %@ → %@",
                                          [[self dateOnlyMediumFormatter] stringFromDate:startDate],
                                          [[self timeOnlyShortFormatter] stringFromDate:startDate],
                                          [[self timeOnlyShortFormatter] stringFromDate:endDate]];
    } else {
        return [NSString stringWithFormat:@"%@ → %@",
                                          [[self mediumFormatter] stringFromDate:startDate],
                                          [[self mediumFormatter] stringFromDate:endDate]];
    }
}

- (NSString *)startDateFullString {
    return [NSString stringWithFormat:@"%@ →", [NSDate.mediumFormatter stringFromDate:self]];
}

- (NSString *)endDateFullString {
    return [NSString stringWithFormat:@"→ %@", [NSDate.mediumFormatter stringFromDate:self]];
}

- (NSString *)fullString {
    return [NSDate.mediumFormatter stringFromDate:self];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
    NSDateComponents *components = [NSDateComponents new];
    components.minute = minutes;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:NSCalendarMatchNextTime];
//    let calendar = NSCalendar.currentCalendar()
//    let dateComponent = NSDateComponents()
//    dateComponent.day = days
//    return calendar.dateByAddingComponents(dateComponent, toDate: self, options: NSCalendarOptions.MatchNextTime)!

}

@end
