//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListModelController.h"

typedef void (^HTLModelControllerContentChangedBlock)();

@class HTLCategoryDto;
@class HTLDateSectionDto;

@interface HTLStatisticsModelController : NSObject

+ (instancetype)modelControllerWithDateSection:(HTLDateSectionDto *)dateSection
                           contentChangedBlock:(HTLModelControllerContentChangedBlock)block;

@property(nonatomic, copy) HTLDateSectionDto *dateSection;

@property(nonatomic, readonly) NSArray *categories;

- (NSTimeInterval)totalTimeForCategory:(HTLCategoryDto *)category;

@end
