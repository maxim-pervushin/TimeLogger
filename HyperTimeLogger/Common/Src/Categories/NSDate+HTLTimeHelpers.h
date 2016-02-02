//
// Created by Maxim Pervushin on 28/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *htlStringWithTimeInterval(NSTimeInterval timeInterval);

@interface NSDate (HTLTimeHelpers)

+ (NSString *)stringWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (NSString *)startDateFullString;

- (NSString *)endDateFullString;

- (NSString *)fullString;

@end

