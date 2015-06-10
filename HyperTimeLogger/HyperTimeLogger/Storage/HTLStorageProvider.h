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

- (BOOL)resetContent;

// Categories

- (NSArray *)categories;

- (NSArray *)categoriesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (BOOL)addCategory:(HTLCategoryDto *)category;

// Reports

- (NSArray *)dateSections;

- (NSArray *)reportsExtended;

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection;

- (NSArray *)reportsExtendedWithCategory:(HTLCategoryDto *)category fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (BOOL)addReportExtended:(HTLReportExtendedDto *)reportExtended;

- (NSDate *)lastReportEndDate;

- (HTLReportExtendedDto *)lastReportExtended;

// Completions

- (NSArray *)completionsForText:(NSString *)text;

@end
