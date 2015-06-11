//
// Created by Maxim Pervushin on 09/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


@class HTLReportExtendedDto;

@interface HTETodayModelController : NSObject

- (NSArray *)completions:(NSUInteger)numberOfCompletions;

- (BOOL)createReportExtended:(HTLReportExtendedDto *)reportExtended;

- (NSDate *)lastReportEndDate;

- (HTLReportExtendedDto *)lastReportExtended;

@end
