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

// TODO: Do we need it???
- (NSArray *)categories;

- (NSArray *)categoriesWithDateSection:(HTLDateSectionDto *)dateSection;

- (BOOL)storeCategory:(HTLCategoryDto *)category;

// Reports

- (NSArray *)reportSections;

// TODO: Do we need it???
- (NSArray *)reportsExtended;

// TODO:countOfReportsWithDateSection:
// - (NSUInteger)countOfReportsWithDateSection:(HTLDateSectionDto *)dateSection;

// TODO: Do we need it???
- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection;

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection category:(HTLCategoryDto *)category;

- (BOOL)storeReportExtended:(HTLReportExtendedDto *)reportExtended;

- (NSDate *)lastReportEndDate;

- (HTLReportExtendedDto *)lastReportExtended;

// Completions

- (NSArray *)completionsWithText:(NSString *)text;

@end
