//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"

@class HTLDateSection;
@class HTLReport;


@interface HTLReportListDataSource : HTLDataSource

@property(nonatomic, assign) HTLDateSection *selectedDateSection;
@property(nonatomic, readonly) NSArray *statistics;

- (BOOL)hasPreviousDateSection;

- (BOOL)hasNextDateSection;

- (void)incrementCurrentDateSectionIndex;

- (void)decrementCurrentDateSectionIndex;

- (NSUInteger)numberOfReports;

- (HTLReport *)reportAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadStatistics;

- (BOOL)saveReport:(HTLReport *)report;

@end