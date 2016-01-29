//
// Created by Maxim Pervushin on 28/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import "NSDate+HTLFormatted.h"


@implementation NSDate (HTLFormatted)

- (NSDateFormatter *)fullDateFormatter {
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


- (NSString *)startDateFullString {
    return [NSString stringWithFormat:@"%@ →", [self.fullDateFormatter stringFromDate:self]];
}

- (NSString *)endDateFullString {
    return [NSString stringWithFormat:@"→ %@", [self.fullDateFormatter stringFromDate:self]];
}

@end

NSString *stringWithTimeInterval(NSTimeInterval timeInterval) {
    NSInteger ti = (NSInteger) timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);

    return [NSString stringWithFormat:NSLocalizedString(@"%02ld:%02ld:%02ld", @"Duration string format"),
                                      (long) hours, (long) minutes, (long) seconds];
}