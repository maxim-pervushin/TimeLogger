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

- (NSArray *)findCategoriesWithDateSection:(HTLDateSection *)dateSection;

- (BOOL)storeCategory:(HTLCategory *)category;

// Report sections

- (NSUInteger)numberOfReportSections;

- (NSArray *)findAllReportSections;

// Reports

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection;

- (NSArray *)findReportsExtendedWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category;

- (BOOL)storeReportExtended:(HTLReportExtended *)reportExtended;

- (NSDate *)findLastReportEndDate;

- (HTLReportExtended *)findLastReportExtended;

// Completions

- (NSArray *)findCompletionsWithText:(NSString *)text;

@end
