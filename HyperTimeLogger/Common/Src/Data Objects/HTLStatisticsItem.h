//
// Created by Maxim Pervushin on 07/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLMark;


@interface HTLStatisticsItem : NSObject <NSCopying, NSObject>

+ (instancetype)statisticsItemWithMark:(HTLMark *)mark totalTime:(NSTimeInterval)totalTime totalReports:(NSUInteger)totalReports;

@property(nonatomic, readonly) HTLMark *mark;
@property(nonatomic, readonly) NSTimeInterval totalTime;
@property(nonatomic, readonly) NSUInteger totalReports;

@end