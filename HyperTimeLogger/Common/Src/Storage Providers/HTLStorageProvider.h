//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import <Foundation/Foundation.h>


// TODO: Use delegation here
static NSString *const kHTLStorageProviderChangedNotification = @"HTLStorageProviderChangedNotification";


@class HTLActivity;
@class HTLDateSection;
@class HTLReport;


@protocol HTLStorageProvider <NSObject>

- (BOOL)clear;

// Categories

- (NSArray *)mandatoryCategories;

- (NSArray *)customCategories;

//- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSection *)dateSection;
//
//- (NSArray *)categoriesWithDateSection:(HTLDateSection *)dateSection;

- (BOOL)saveCategory:(HTLActivity *)category;

- (BOOL)deleteCategory:(HTLActivity *)category;

// Date sections

- (NSUInteger)numberOfDateSections;

- (NSArray *)dateSections;

// Reports

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection;

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection category:(HTLActivity *)category;

- (BOOL)saveReport:(HTLReport *)report;

- (NSDate *)lastReportEndDate;

- (HTLReport *)lastReport;

// Statistics

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection;

@end
