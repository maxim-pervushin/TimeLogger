//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import "HTLDataSource.h"


@class HTLAction;
@class HTLCategory;
@class HTLReportExtended;
@class HTLReport;


// TODO: Split to data source and logic. Actually this scene will be deleted
@interface HTLEditReportModelController : HTLDataSource

+ (instancetype)modelControllerWithReportExtended:(HTLReportExtended *)reportExtended
                              contentChangedBlock:(HTLDataSourceChangedBlock)block;

@property(nonatomic, readonly) NSArray *completions;
@property(nonatomic, readonly) NSArray *categories;
@property(nonatomic, readonly) HTLReportExtended *reportExtended;

@property(nonatomic, copy) HTLReport *report;
@property(nonatomic, copy) HTLAction *action;
@property(nonatomic, copy) HTLCategory *category;

- (BOOL)save;

@end
