//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import <Foundation/Foundation.h>


@class HTLMark;
@class HTLDateSection;
@class HTLReport;


@protocol HTLStorageProvider <NSObject>

- (BOOL)clear;

// Marks

- (NSArray *)mandatoryMarks;

- (NSArray *)customMarks;

- (BOOL)saveMark:(HTLMark *)mark;

- (BOOL)deleteMark:(HTLMark *)mark;

// Date sections

- (NSUInteger)numberOfDateSections;

- (NSArray *)dateSections;

// Reports

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection;

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection mark:(HTLMark *)mark;

- (BOOL)saveReport:(HTLReport *)report;

- (NSDate *)lastReportEndDate;

- (HTLReport *)lastReport;

// Statistics

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection;

@end
