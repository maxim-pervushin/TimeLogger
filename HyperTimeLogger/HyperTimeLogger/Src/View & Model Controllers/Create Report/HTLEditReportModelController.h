//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import "HTLModelController.h"


@class HTLActionDto;
@class HTLCategoryDto;
@class HTLReportExtendedDto;
@class HTLReportDto;


@interface HTLEditReportModelController : HTLModelController

+ (instancetype)modelControllerWithReportExtended:(HTLReportExtendedDto *)reportExtended
                              contentChangedBlock:(HTLModelControllerContentChangedBlock)block;

@property(nonatomic, readonly) NSArray *completions;
@property(nonatomic, readonly) NSArray *categories;
@property(nonatomic, readonly) HTLReportExtendedDto *reportExtended;

@property(nonatomic, copy) HTLReportDto *report;
@property(nonatomic, copy) HTLActionDto *action;
@property(nonatomic, copy) HTLCategoryDto *category;

- (BOOL)save;

@end
