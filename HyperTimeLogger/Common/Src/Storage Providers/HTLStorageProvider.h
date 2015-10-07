//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import <Foundation/Foundation.h>


// TODO: Use delegation here
static NSString *const kHTLStorageProviderChangedNotification = @"HTLStorageProviderChangedNotification";


@class HTLCategory;
@class HTLDateSection;
@class HTLReport;


@protocol HTLStorageProvider <NSObject>

- (BOOL)clear;

// Categories

- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSection *)dateSection;

- (NSArray *)categoriesWithDateSection:(HTLDateSection *)dateSection;

- (BOOL)saveCategory:(HTLCategory *)category;

- (BOOL)deleteCategory:(HTLCategory *)category;

// Date sections

- (NSUInteger)numberOfDateSections;

- (NSArray *)dateSections;

// Reports

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection;

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category;

- (BOOL)saveReport:(HTLReport *)report;

- (NSDate *)lastReportEndDate;

- (HTLReport *)lastReport;

@end
