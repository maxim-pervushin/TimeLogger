//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import "HTLDataSource.h"


@class HTLActionDto;
@class HTLCategoryDto;
@class HTLReportExtendedDto;
@class HTLReportDto;


@interface HTLEditReportDataSource : HTLDataSource

@property(nonatomic, readonly) NSArray *categories;

@property(nonatomic, readonly) NSDate *startDate;

- (NSArray *)completionsForAction:(HTLActionDto *)action;

- (BOOL)saveReportExtended:(HTLReportExtendedDto *)reportExtended;

@end
