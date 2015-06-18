//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "NSDate+HTLComponents.h"

@implementation NSDate (HTLComponents)

+ (NSDateFormatter *)dateComponentFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    return formatter;
}

+ (NSDateFormatter *)timeComponentFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"HH:mm:ss";
    });
    return formatter;
}

+ (NSDateFormatter *)zoneComponentFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"ZZZ";
    });
    return formatter;
}

+ (NSDateFormatter *)fullFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
    });
    return formatter;
}

- (BOOL)getDateString:(NSString **)dateString timeString:(NSString **)timeString timeZoneString:(NSString **)timeZoneString {
    if (!self) {
        return NO;
    }

    *timeString = [[NSDate timeComponentFormatter] stringFromDate:self];
    *dateString = [[NSDate dateComponentFormatter] stringFromDate:self];
    *timeZoneString = [[NSDate zoneComponentFormatter] stringFromDate:self];

    return YES;
}

+ (NSDate *)dateWithDateString:(NSString *)dateString timeString:(NSString *)timeString timeZoneString:(NSString *)timeZoneString {
    NSString *assembled = [NSString stringWithFormat:@"%@ %@ %@", dateString, timeString, timeZoneString];
    return [[NSDate fullFormatter] dateFromString:assembled];
}


@end