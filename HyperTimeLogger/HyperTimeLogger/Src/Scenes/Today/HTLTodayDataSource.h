//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"

@class HTLActivity;


@interface HTLTodayDataSource : HTLDataSource

@property(nonatomic, readonly) NSTimeInterval currentInterval;

- (NSUInteger)numberOfMandatoryCategories;

- (NSUInteger)numberOfCustomCategories;

- (HTLActivity *)mandatoryCategoryAtIndex:(NSInteger)index;

- (HTLActivity *)customCategoryAtIndex:(NSInteger)index;

- (BOOL)saveReportWithMandatoryCategoryAtIndex:(NSInteger)index;

- (BOOL)saveReportWithCustomCategoryAtIndex:(NSInteger)index;

@end