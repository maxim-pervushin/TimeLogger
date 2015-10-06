//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"

@class HTLDateSection;


@interface HTLReportDateListDataSource : HTLDataSource

@property(nonatomic, copy) HTLDateSection *selectedDateSection;

- (NSUInteger)numberOfDateSections;

- (HTLDateSection *)dateSectionAtIndexPath:(NSIndexPath *)indexPath;

@end