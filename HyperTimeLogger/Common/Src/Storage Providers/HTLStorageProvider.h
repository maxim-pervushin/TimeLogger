//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import <Foundation/Foundation.h>


static NSString *const kHTLStorageProviderChangedNotification = @"HTLStorageProviderChangedNotification";


@class HTLReportExtendedDto;
@class HTLCategoryDto;
@class HTLDateSectionDto;


@protocol HTLStorageProvider <NSObject>

- (BOOL)clear;

// Categories

- (NSArray *)categories;

- (NSArray *)categoriesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (BOOL)storeCategory:(HTLCategoryDto *)category;

// Reports

- (NSArray *)reportSections;

- (NSArray *)reportsExtended;

- (NSArray *)reportsExtendedWithSection:(HTLDateSectionDto *)dateSection;

- (NSArray *)reportsExtendedWithCategory:(HTLCategoryDto *)category fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (BOOL)storeReportExtended:(HTLReportExtendedDto *)reportExtended;

- (NSDate *)lastReportEndDate;

- (HTLReportExtendedDto *)lastReportExtended;

// Completions

- (NSArray *)completionsWithText:(NSString *)text;

@end
