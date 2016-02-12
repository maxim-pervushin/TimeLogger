//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"

@class HTLMark;
@class HTLReport;

@interface HTLTodayDataSource : HTLDataSource

@property(nonatomic, readonly) NSDate *lastReportEndDate;

@property(nonatomic, readonly) HTLReport *lastReport;

@property(nonatomic, readonly) NSTimeInterval currentInterval;

- (NSUInteger)numberOfMarks;

- (HTLMark *)markAtIndex:(NSInteger)index;

- (BOOL)saveReportWithMarkAtIndex:(NSInteger)index;

- (BOOL)saveReportWithMark:(HTLMark *)mark;

- (BOOL)saveReport:(HTLReport *)report;

@end
