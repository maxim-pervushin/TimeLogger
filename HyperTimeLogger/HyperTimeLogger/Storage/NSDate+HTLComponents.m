//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "NSDate+HTLComponents.h"

@implementation NSDate (HTLComponents)

+ (NSDateFormatter *)dateComponentFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    return formatter;
}

+ (NSDateFormatter *)timeComponentFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm:ss";
    return formatter;
}

+ (NSDateFormatter *)zoneComponentFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"z";
    return formatter;
}

+ (NSDateFormatter *)fullFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
    return formatter;
}

- (void)disassembleToDateInterval:(NSTimeInterval *)dateInterval timeInterval:(NSTimeInterval *)timeInterval zone:(NSString **)zone {
    NSString *dateComponentString = [[NSDate dateComponentFormatter] stringFromDate:self];
    NSDate *dateComponent = [[NSDate dateComponentFormatter] dateFromString:dateComponentString];
    *dateInterval = dateComponent.timeIntervalSince1970;

    NSString *timeComponentString = [[NSDate timeComponentFormatter] stringFromDate:self];
    NSDate *timeComponent = [[NSDate timeComponentFormatter] dateFromString:timeComponentString];
    *timeInterval = timeComponent.timeIntervalSince1970;

    *zone = [[NSDate zoneComponentFormatter] stringFromDate:self];
}

+ (NSDate *)dateWithDateInterval:(NSTimeInterval)dateInterval timeInterval:(NSTimeInterval)timeInterval zone:(NSString *)zone {
    NSDate *dateComponentAssembled = [NSDate dateWithTimeIntervalSince1970:dateInterval];
    NSString *dateComponentAssembledString = [[NSDate dateComponentFormatter] stringFromDate:dateComponentAssembled];
    NSDate *timeComponentAssembled = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *timeComponentAssembledString = [[NSDate timeComponentFormatter] stringFromDate:timeComponentAssembled];

    return [[NSDate fullFormatter] dateFromString:[NSString stringWithFormat:@"%@ %@ %@", dateComponentAssembledString, timeComponentAssembledString, zone]];
}

@end