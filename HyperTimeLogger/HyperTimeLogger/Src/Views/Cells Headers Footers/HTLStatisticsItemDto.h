//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HTLCategoryDto;


@interface HTLStatisticsItemDto : NSObject <NSCopying>

+ (instancetype)statisticsItemWithCategory:(HTLCategoryDto *)category totalTime:(NSTimeInterval)totalTime totalReports:(NSUInteger)totalReports;

- (instancetype)initWithCategory:(HTLCategoryDto *)category totalTime:(NSTimeInterval)totalTime totalReports:(NSUInteger)totalReports;

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToDto:(HTLStatisticsItemDto *)dto;

- (NSUInteger)hash;

@property(nonatomic, readonly) HTLCategoryDto *category;
@property(nonatomic, readonly) NSTimeInterval totalTime;
@property(nonatomic, readonly) NSUInteger totalReports;

@end
