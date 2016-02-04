//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"


@class HTLReportDto;


@interface HTLReportListDataSource : HTLDataSource

@property(nonatomic, readonly) NSUInteger numberOfReportSections;

@property(nonatomic, readonly) NSArray *reportSections;

@property(nonatomic, readonly) NSDate *startDate;

- (NSUInteger)numberOfReportsForDateSectionAtIndex:(NSInteger)index;

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index;

@end
