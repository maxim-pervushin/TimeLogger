//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"

@class HTLCategory;
@class HTLReportExtended;


@interface HTLTodayDataSource : HTLDataSource

@property(nonatomic, readonly) NSTimeInterval currentInterval;
@property(nonatomic, readonly) NSUInteger numberOfCategories;

- (HTLCategory *)categoryAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)saveReportWithCategoryAtIndexPath:(NSIndexPath *)indexPath;

@end