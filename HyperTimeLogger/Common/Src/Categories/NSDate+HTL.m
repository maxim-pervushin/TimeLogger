//
// Created by Maxim Pervushin on 05/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "NSDate+HTL.h"

NSString *HTLDurationFullString(NSTimeInterval timeInterval) {
    NSInteger ti = (NSInteger) timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:NSLocalizedString(@"%02ld:%02ld:%02ld", @"Duration string format"),
                                      (long) hours, (long) minutes, (long) seconds];
}

@implementation NSDate (HTL)

- (NSDateFormatter *)shortDateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        formatter.timeZone = [NSTimeZone localTimeZone];
    });
    return formatter;
}

- (NSDateFormatter *)mediumDateFormatter {
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

- (NSString *)shortString {
    return [self.shortDateFormatter stringFromDate:self];
}

- (NSString *)mediumString {
    return [self.mediumDateFormatter stringFromDate:self];
}

@end