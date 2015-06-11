//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLReportDto;


@interface HTLReportListModelController : NSObject

@property(nonatomic, readonly) NSUInteger reportsExtendedCount;
@property(nonatomic, readonly) NSArray *reportsExtended;

@property(nonatomic, readonly) NSArray *dateSections;

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index;

- (void)createTestData;

@end


