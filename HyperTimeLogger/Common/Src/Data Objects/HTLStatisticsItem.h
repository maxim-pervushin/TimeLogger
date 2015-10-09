//
// Created by Maxim Pervushin on 07/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLActivity;


@interface HTLStatisticsItem : NSObject <NSCopying, NSObject>

+ (instancetype)statisticsItemWithCategory:(HTLActivity *)category totalTime:(NSTimeInterval)totalTime totalReports:(NSUInteger)totalReports;

@property(nonatomic, readonly) HTLActivity *category;
@property(nonatomic, readonly) NSTimeInterval totalTime;
@property(nonatomic, readonly) NSUInteger totalReports;

@end