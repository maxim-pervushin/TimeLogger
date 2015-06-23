//
// Created by Maxim Pervushin on 10/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportDto+Helpers.h"

@implementation HTLReportDto (Helpers)

- (NSDateFormatter *)dateFormatter {
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

- (NSTimeInterval)duration {
    return [self.endDate timeIntervalSinceDate:self.startDate];
}

- (NSString *)durationString {
    NSInteger ti = (NSInteger) self.duration;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:NSLocalizedString(@"%02ld:%02ld:%02ld", @"Duration string format"),
                    (long) hours, (long) minutes, (long) seconds];
}

- (NSString *)startDateString {
    return [self.dateFormatter stringFromDate:self.startDate];
}

- (NSString *)endDateString {
    return [self.dateFormatter stringFromDate:self.endDate];
}

@end