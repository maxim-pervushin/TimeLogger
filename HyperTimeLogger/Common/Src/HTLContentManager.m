//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLContentManager.h"
#import "HTLReportDto.h"
#import "HTLSqliteStorageProvider.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLReportExtendedDto.h"
#import "HTLDateSectionDto.h"


@interface HTLContentManager ()

@property(nonatomic, strong) id <HTLStorageProvider> storageProvider;
@property(nonatomic, strong) HTLCSVStringExportProvider *csvStringExportProvider;

- (void)initializeStorage;

@end

@implementation HTLContentManager

+ (instancetype)defaultManager {
    static HTLContentManager *defaultManager = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        defaultManager = [self new];
        defaultManager.storageProvider = [HTLSqliteStorageProvider new];
        defaultManager.csvStringExportProvider = [HTLCSVStringExportProvider new];
        [defaultManager initializeStorage];
    });
    return defaultManager;
}

- (void)initializeStorage {
    // Check categories.
    if ([self.storageProvider categories].count == 0) {
        NSArray *initialCategories = @[
                [HTLCategoryDto categoryWithIdentifier:@"0" title:@"Sleep" color:[UIColor paperColorDeepPurple]],
                [HTLCategoryDto categoryWithIdentifier:@"1" title:@"Personal" color:[UIColor paperColorIndigo]],
                [HTLCategoryDto categoryWithIdentifier:@"2" title:@"Road" color:[UIColor paperColorRed]],
                [HTLCategoryDto categoryWithIdentifier:@"3" title:@"Work" color:[UIColor paperColorLightGreen]],
                [HTLCategoryDto categoryWithIdentifier:@"4" title:@"Improvement" color:[UIColor paperColorDeepOrange]],
                [HTLCategoryDto categoryWithIdentifier:@"5" title:@"Recreation" color:[UIColor paperColorCyan]],
                [HTLCategoryDto categoryWithIdentifier:@"6" title:@"Time Waste" color:[UIColor paperColorBrown]]
        ];

        for (HTLCategoryDto *category in initialCategories) {
            [self.storageProvider storeCategory:category];
        }
    }
}

- (BOOL)clear {
    BOOL result = [self.storageProvider clear];
    [self initializeStorage];
    return result;
}

- (NSArray *)categories {
    return [self.storageProvider categories];
}

- (NSArray *)categoriesWithDateSection:(HTLDateSectionDto *)dateSection {
    return [self.storageProvider categoriesWithDateSection:dateSection];
}

- (BOOL)storeCategory:(HTLCategoryDto *)category {
    return [self.storageProvider storeCategory:category];
}

- (NSArray *)completionsWithText:(NSString *)text {
    return [self.storageProvider completionsWithText:text];
}

- (NSArray *)reportsExtended {
    return self.storageProvider.reportsExtended;
}

- (NSArray *)reportSections {
    return [self.storageProvider reportSections];
}

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection {
    return [self.storageProvider reportsExtendedWithDateSection:dateSection];
}

- (BOOL)storeReportExtended:(HTLReportExtendedDto *)reportExtended {
    return [self.storageProvider storeReportExtended:reportExtended];
}

- (NSString *)exportDataToCSV {
    return [self.csvStringExportProvider exportReportsExtended:[self.storageProvider reportsExtended]];
}

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection category:(HTLCategoryDto *)category {
    return [self.storageProvider reportsExtendedWithDateSection:dateSection category:category];
}

- (NSDate *)lastReportEndDate {
    return [self.storageProvider lastReportEndDate];
}

- (HTLReportExtendedDto *)lastReportExtended {
    return [self.storageProvider lastReportExtended];
}

@end