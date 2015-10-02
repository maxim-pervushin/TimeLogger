//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import <Foundation/Foundation.h>


static NSString *const kHTLStorageProviderChangedNotification = @"HTLStorageProviderChangedNotification";


@class HTLReportExtended;
@class HTLCategory;
@class HTLDateSection;


@protocol HTLStorageProvider <NSObject>

- (BOOL)clear;

// Categories

- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSection *)dateSection;

- (NSArray *)categoriesWithDateSection:(HTLDateSection *)dateSection;

- (BOOL)saveCategory:(HTLCategory *)category;

// Report sections

- (NSUInteger)numberOfReportSections;

- (NSArray *)reportSections;

// Reports

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection;

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category;

- (BOOL)saveReportExtended:(HTLReportExtended *)reportExtended;

- (NSDate *)lastReportEndDate;

- (HTLReportExtended *)lastReportExtended;

// Completions

- (NSArray *)completionsWithText:(NSString *)text;

@end
