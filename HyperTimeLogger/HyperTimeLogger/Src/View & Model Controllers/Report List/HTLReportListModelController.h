//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLModelController.h"


@class HTLReportDto;


@interface HTLReportListModelController : HTLModelController

@property(nonatomic, readonly) NSArray *reportSections;

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index;

@end
