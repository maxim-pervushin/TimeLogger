//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"

@class HTLActivity;

@interface HTLToday_NewDataSource : HTLDataSource

@property(nonatomic, readonly) NSTimeInterval currentInterval;

- (NSUInteger)numberOfActivities;

- (HTLActivity *)activityAtIndex:(NSInteger)index;

- (BOOL)saveReportWithActivityAtIndex:(NSInteger)index;

@end
