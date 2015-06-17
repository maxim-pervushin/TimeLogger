//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLModelController.h"


@class HTLCategoryDto;
@class HTLDateSectionDto;
@class HTLStatisticsItemDto;


@interface HTLStatisticsModelController : HTLModelController

+ (instancetype)modelControllerWithDateSection:(HTLDateSectionDto *)dateSection
                           contentChangedBlock:(HTLModelControllerContentChangedBlock)block;

@property(nonatomic, copy) HTLDateSectionDto *dateSection;

@property(nonatomic, readonly) NSArray *categories;

- (HTLStatisticsItemDto *)statisticsForCategory:(HTLCategoryDto *)category;

@end
