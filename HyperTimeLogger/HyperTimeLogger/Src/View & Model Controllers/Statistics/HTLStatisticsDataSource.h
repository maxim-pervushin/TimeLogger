//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"


@class HTLCategory;
@class HTLDateSection;
@class HTLStatisticsItem;


@interface HTLStatisticsDataSource : HTLDataSource

+ (instancetype)dataSourceWithDateSection:(HTLDateSection *)dateSection
                         dataChangedBlock:(HTLDataSourceDataChangedBlock)block;

@property(nonatomic, copy) HTLDateSection *dateSection;

@property(nonatomic, readonly) BOOL loaded;
@property(nonatomic, readonly) NSArray *categories;
@property(nonatomic, readonly) NSTimeInterval totalTime;

- (void)reloadData;

- (HTLStatisticsItem *)statisticsForCategory:(HTLCategory *)category;

@end
