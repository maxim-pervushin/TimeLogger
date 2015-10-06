//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"

@class HTLDateSection;
@class HTLReportExtended;


@interface HTLReportListDataSource : HTLDataSource

@property (nonatomic, assign) HTLDateSection *selectedDateSection;

- (BOOL)hasPreviousDateSection;

- (BOOL)hasNextDateSection;

- (void)incrementCurrentDateSectionIndex;

- (void)decrementCurrentDateSectionIndex;

- (NSUInteger)numberOfReports;

- (HTLReportExtended *)reportAtIndexPath:(NSIndexPath *)indexPath;

@end