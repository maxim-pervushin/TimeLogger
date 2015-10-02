//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLContentManager.h"
#import "HTLReport.h"
#import "HTLSqliteStorageProvider.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLReportExtended.h"
#import "HTLDateSection.h"
#import "HTLStringExportProvider.h"


@interface HTLContentManager ()

@property(nonatomic, strong) id <HTLStorageProvider> storageProvider;
@property(nonatomic, strong) HTLCSVStringExportProvider *csvStringExportProvider;

- (void)initializeStorage;

@end

@implementation HTLContentManager

+ (instancetype)contentManagerWithStorageProvider:(id <HTLStorageProvider>)storageProvider exportProvider:(id <HTLStringExportProvider>)exportProvider {
    HTLContentManager *contentManager = [HTLContentManager new];
    contentManager.storageProvider=  storageProvider;
    contentManager.csvStringExportProvider = exportProvider;
    [contentManager initializeStorage];
    return contentManager;
}

- (void)initializeStorage {
    // Check categories.
    if ([self.storageProvider categoriesWithDateSection:nil].count == 0) {
        NSArray *initialCategories = @[
                [HTLCategory categoryWithIdentifier:@"0" title:@"Sleep" color:[UIColor paperColorDeepPurple]],
                [HTLCategory categoryWithIdentifier:@"1" title:@"Personal" color:[UIColor paperColorIndigo]],
                [HTLCategory categoryWithIdentifier:@"2" title:@"Road" color:[UIColor paperColorRed]],
                [HTLCategory categoryWithIdentifier:@"3" title:@"Work" color:[UIColor paperColorLightGreen]],
                [HTLCategory categoryWithIdentifier:@"4" title:@"Improvement" color:[UIColor paperColorDeepOrange]],
                [HTLCategory categoryWithIdentifier:@"5" title:@"Recreation" color:[UIColor paperColorCyan]],
                [HTLCategory categoryWithIdentifier:@"6" title:@"Time Waste" color:[UIColor paperColorBrown]]
        ];

        for (HTLCategory *category in initialCategories) {
            [self.storageProvider saveCategory:category];
        }
    }
}

- (BOOL)clear {
    BOOL result = [self.storageProvider clear];
    [self initializeStorage];
    return result;
}

- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSection *)dateSection {
    return [self.storageProvider numberOfCategoriesWithDateSection:dateSection];
}

- (NSArray *)categoriesWithDateSection:(HTLDateSection *)dateSection {
    return [self.storageProvider categoriesWithDateSection:dateSection];
}

- (BOOL)saveCategory:(HTLCategory *)category {
    return [self.storageProvider saveCategory:category];
}

- (NSArray *)completionsWithText:(NSString *)text {
    return [self.storageProvider completionsWithText:text];
}

- (NSUInteger)numberOfReportSections {
    return [self.storageProvider numberOfReportSections];
}

- (NSArray *)reportSections {
    return [self.storageProvider reportSections];
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection {
    return [self.storageProvider numberOfReportsWithDateSection:dateSection];
}

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category {
    return [self.storageProvider reportsExtendedWithDateSection:dateSection category:category];
}

- (BOOL)saveReportExtended:(HTLReportExtended *)reportExtended {
    return [self.storageProvider saveReportExtended:reportExtended];
}

- (NSString *)exportDataToCSV {
    return [self.csvStringExportProvider exportReportsExtended:[self.storageProvider reportsExtendedWithDateSection:nil category:nil]];
}

- (NSDate *)lastReportEndDate {
    return [self.storageProvider lastReportEndDate];
}

- (HTLReportExtended *)lastReportExtended {
    return [self.storageProvider lastReportExtended];
}

@end