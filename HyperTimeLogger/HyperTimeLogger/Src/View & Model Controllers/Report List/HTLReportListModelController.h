//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^HTLModelControllerContentChangedBlock)();

@class HTLReportDto;


@interface HTLReportListModelController : NSObject

+ (instancetype)modelControllerWithContentChangedBlock:(HTLModelControllerContentChangedBlock)block;

@property(nonatomic, readonly) NSArray *reportSections;

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index;

@end


