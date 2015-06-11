//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLActionDto;
@class HTLCategoryDto;


@interface HTLReportExtendedDto : NSObject

+ (instancetype)reportWithAction:(HTLActionDto *)action category:(HTLCategoryDto *)category startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (instancetype)initWithAction:(HTLActionDto *)action category:(HTLCategoryDto *)category startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@property(nonatomic, readonly) HTLActionDto *action;
@property(nonatomic, readonly) HTLCategoryDto *category;
@property(nonatomic, readonly) NSDate *startDate;
@property(nonatomic, readonly) NSDate *endDate;

@end

