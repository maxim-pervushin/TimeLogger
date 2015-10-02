//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"


@class HTLCategory;
@class HTLDateSection;
@class HTLStatisticsItemDto;


@interface HTLStatisticsDataSource : HTLDataSource

+ (instancetype)dataSourceWithDateSection:(HTLDateSection *)dateSection
                      contentChangedBlock:(HTLDataSourceChangedBlock)block;

@property(nonatomic, copy) HTLDateSection *dateSection;

@property(nonatomic, readonly) NSArray *categories;

- (void)reloadData;

- (HTLStatisticsItemDto *)statisticsForCategory:(HTLCategory *)category;

@end
