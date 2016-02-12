//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import "HTLDataSource.h"


@class HTLAction;
@class HTLCategory;
@class HTLReportExtended;
@class HTLReport;


@interface HTLEditReportDataSource : HTLDataSource

@property(nonatomic, readonly) NSArray *categories;

@property(nonatomic, readonly) NSDate *startDate;

- (NSArray *)completionsForAction:(HTLAction *)action;

- (BOOL)saveReportExtended:(HTLReportExtended *)reportExtended;

@end
