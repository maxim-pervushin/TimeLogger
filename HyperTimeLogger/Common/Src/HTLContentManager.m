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

//- (void)initializeStorage;

@end

@implementation HTLContentManager

+ (instancetype)contentManagerWithStorageProvider:(id <HTLStorageProvider>)storageProvider exportProvider:(id <HTLStringExportProvider>)exportProvider {
    HTLContentManager *contentManager = [HTLContentManager new];
    contentManager.storageProvider=  storageProvider;
    contentManager.csvStringExportProvider = exportProvider;
//    [contentManager initializeStorage];
    return contentManager;
}

//- (void)initializeStorage {
//    // Check categories.
//    if (self.storageProvider.customCategories.count == 0) {
//        NSArray *initialCategories = @[
//                [HTLActivity categoryWithTitle:@"Sleep" subTitle:@"" color:[UIColor paperColorDeepPurple]],
//                [HTLActivity categoryWithTitle:@"Personal" subTitle:@"" color:[UIColor paperColorIndigo]],
//                [HTLActivity categoryWithTitle:@"Road" subTitle:@"" color:[UIColor paperColorRed]],
//                [HTLActivity categoryWithTitle:@"Work" subTitle:@"" color:[UIColor paperColorLightGreen]],
//                [HTLActivity categoryWithTitle:@"Improvement" subTitle:@"" color:[UIColor paperColorDeepOrange]],
//                [HTLActivity categoryWithTitle:@"Recreation" subTitle:@"" color:[UIColor paperColorCyan]],
//                [HTLActivity categoryWithTitle:@"Time Waste" subTitle:@"" color:[UIColor paperColorBrown]]
//        ];
//
//        for (HTLActivity *category in initialCategories) {
//            [self.storageProvider saveCategory:category];
//        }
//    }
//}

- (BOOL)clear {
    BOOL result = [self.storageProvider clear];
//    [self initializeStorage];
    return result;
}

- (NSArray *)mandatoryCategories {
    return self.storageProvider.mandatoryCategories;
}

- (NSArray *)customCategories {
    return self.storageProvider.customCategories;
}

//- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSection *)dateSection {
//    return [self.storageProvider numberOfCategoriesWithDateSection:dateSection];
//}
//
//- (NSArray *)categoriesWithDateSection:(HTLDateSection *)dateSection {
//    return [self.storageProvider categoriesWithDateSection:dateSection];
//}

- (BOOL)saveCategory:(HTLActivity *)category {
    return [self.storageProvider saveCategory:category];
}

- (BOOL)deleteCategory:(HTLActivity *)category {
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

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection category:(HTLActivity *)category {
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

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection {
    return [self.storageProvider statisticsWithDateSection:dateSection];
}

@end