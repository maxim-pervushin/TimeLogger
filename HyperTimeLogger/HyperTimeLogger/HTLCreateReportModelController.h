//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import <Foundation/Foundation.h>


@class HTLReportDto;
@class HTLReportExtendedDto;

@interface HTLCreateReportModelController : NSObject

- (NSArray *)getCompletionsForText:(NSString *)text;

- (NSArray *)getCategories;

- (BOOL)createReportExtended:(HTLReportExtendedDto *)reportExtended;

- (NSDate *)lastReportEndDate;

@end
