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

- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSectionDto *)dateSection;

- (NSArray *)findCategoriesWithDateSection:(HTLDateSectionDto *)dateSection;

- (BOOL)storeCategory:(HTLCategoryDto *)category;

// Report sections

- (NSUInteger)numberOfReportSections;

- (NSArray *)findAllReportSections;

// Reports

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSectionDto *)dateSection;

- (NSArray *)findReportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection category:(HTLCategoryDto *)category;

- (BOOL)storeReportExtended:(HTLReportExtendedDto *)reportExtended;

- (NSDate *)findLastReportEndDate;

- (HTLReportExtendedDto *)findLastReportExtended;

// Completions

- (NSArray *)findCompletionsWithText:(NSString *)text;

@end
