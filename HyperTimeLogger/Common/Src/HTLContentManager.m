//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStorageProvider.h"
#import "HTLContentManager.h"
#import "HTLReport.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLDateSection.h"
#import "UIColor+BFPaperColors.h"


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
                [HTLCategory categoryWithIdentifier:@"0" title:@"Sleep" subTitle:@"" color:[UIColor paperColorDeepPurple]],
                [HTLCategory categoryWithIdentifier:@"1" title:@"Personal" subTitle:@"" color:[UIColor paperColorIndigo]],
                [HTLCategory categoryWithIdentifier:@"2" title:@"Road" subTitle:@"" color:[UIColor paperColorRed]],
                [HTLCategory categoryWithIdentifier:@"3" title:@"Work" subTitle:@"" color:[UIColor paperColorLightGreen]],
                [HTLCategory categoryWithIdentifier:@"4" title:@"Improvement" subTitle:@"" color:[UIColor paperColorDeepOrange]],
                [HTLCategory categoryWithIdentifier:@"5" title:@"Recreation" subTitle:@"" color:[UIColor paperColorCyan]],
                [HTLCategory categoryWithIdentifier:@"6" title:@"Time Waste" subTitle:@"" color:[UIColor paperColorBrown]]
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

- (BOOL)deleteCategory:(HTLCategory *)category {
    return [self.storageProvider deleteCategory:category];
}

- (NSUInteger)numberOfDateSections {
    return [self.storageProvider numberOfDateSections];
}

- (NSArray *)dateSections {
    return [self.storageProvider dateSections];
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection {
    return [self.storageProvider numberOfReportsWithDateSection:dateSection];
}

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category {
    return [self.storageProvider reportsWithDateSection:dateSection category:category];
}

- (BOOL)saveReport:(HTLReport *)report {
    return [self.storageProvider saveReport:report];
}

- (NSString *)exportDataToCSV {
    return [self.csvStringExportProvider exportReportsExtended:[self.storageProvider reportsWithDateSection:nil category:nil]];
}

- (NSDate *)lastReportEndDate {
    return [self.storageProvider lastReportEndDate];
}

- (HTLReport *)lastReport {
    return [self.storageProvider lastReport];
}

@end