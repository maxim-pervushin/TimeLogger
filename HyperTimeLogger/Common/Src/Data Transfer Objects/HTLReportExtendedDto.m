//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportExtendedDto.h"
#import "HTLActionDto.h"
#import "HTLCategoryDto.h"
#import "HTLDateSectionDto.h"


@implementation HTLReportExtendedDto
@synthesize action = action_;
@synthesize category = category_;
@synthesize startDate = startDate_;
@synthesize endDate = endDate_;

+ (instancetype)reportWithAction:(HTLActionDto *)action category:(HTLCategoryDto *)category startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    return [[self alloc] initWithAction:action category:category startDate:startDate endDate:endDate];
}

- (instancetype)initWithAction:(HTLActionDto *)action category:(HTLCategoryDto *)category startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    if (!action || !category || !startDate || !endDate) {
        return nil;
    }

    self = [super init];
    if (self) {
        action_ = [action copy];
        category_ = [category copy];
        startDate_ = [startDate copy];
        endDate_ = [endDate copy];
    }
    return self;
}

@end

