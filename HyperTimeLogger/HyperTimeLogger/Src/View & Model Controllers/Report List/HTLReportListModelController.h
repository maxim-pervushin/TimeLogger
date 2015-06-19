//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLModelController.h"


@class HTLReportDto;


@interface HTLReportListModelController : HTLModelController

@property(nonatomic, readonly) NSUInteger numberOfReportSections;

@property(nonatomic, readonly) NSArray *reportSections;

- (NSUInteger)countOfReportsForDateSectionAtIndex:(NSInteger)index;

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index;

@end
