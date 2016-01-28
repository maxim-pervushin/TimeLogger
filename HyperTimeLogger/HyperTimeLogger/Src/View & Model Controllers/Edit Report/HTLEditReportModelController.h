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

@property(nonatomic, readonly) NSArray *categories;

- (NSArray *)completionsForAction:(HTLActionDto *)action;

- (BOOL)saveReportExtended:(HTLReportExtendedDto *)reportExtended;

@end
