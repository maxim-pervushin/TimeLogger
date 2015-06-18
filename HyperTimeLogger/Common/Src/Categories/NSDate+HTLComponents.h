//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (HTLComponents)

//- (void)disassembleToDateInterval:(NSTimeInterval *)dateInterval timeInterval:(NSTimeInterval *)timeInterval zone:(NSString **)zone;

//+ (NSDate *)dateWithDateInterval:(NSTimeInterval)dateInterval timeInterval:(NSTimeInterval)timeInterval zone:(NSString *)zone;

- (BOOL)getDateString:(NSString **)dateString timeString:(NSString **)timeString timeZoneString:(NSString **)timeZoneString;

+ (NSDate *)dateWithDateString:(NSString *)dateString timeString:(NSString *)timeString timeZoneString:(NSString *)timeZoneString;

@end
