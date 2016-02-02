//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLContentManager.h"
#import "HTLReportDto.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLReportExtendedDto.h"
#import "HTLDateSectionDto.h"
#import "UIColor+FlatColors.h"

@interface HTLContentManager ()

@property(nonatomic, strong) id <HTLStorageProvider> storageProvider;
@property(nonatomic, strong) HTLCSVStringExportProvider *csvStringExportProvider;
@property(nonatomic, strong) NSDate *launchDate;

- (void)initializeLaunchDate;

- (void)initializeStorage;

@end

@implementation HTLContentManager

+ (instancetype)contentManagerWithStorageProvider:(id <HTLStorageProvider>)storageProvider exportProvider:(id <HTLStringExportProvider>)exportProvider {
    HTLContentManager *contentManager = [HTLContentManager new];
    contentManager.storageProvider = storageProvider;
    contentManager.csvStringExportProvider = exportProvider;
    [contentManager initializeLaunchDate];
    [contentManager initializeStorage];
    return contentManager;
}

- (void)initializeLaunchDate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [defaults objectForKey:@"launchDate"];
    if (!date) {
        date = [NSDate new];
        [defaults setObject:date forKey:@"launchDate"];
    }
    self.launchDate = date;
}

- (void)initializeStorage {
    // Check categories.
    if ([self.storageProvider findCategoriesWithDateSection:nil].count == 0) {
        NSArray *initialCategories = @[
                [HTLCategoryDto categoryWithIdentifier:@"0" title:@"Sleep" color:[UIColor flatMidnightBlueColor]],
                [HTLCategoryDto categoryWithIdentifier:@"1" title:@"Personal" color:[UIColor flatPumpkinColor]],
                [HTLCategoryDto categoryWithIdentifier:@"2" title:@"Road" color:[UIColor flatWisteriaColor]],
                [HTLCategoryDto categoryWithIdentifier:@"3" title:@"Work" color:[UIColor flatNephritisColor]],
                [HTLCategoryDto categoryWithIdentifier:@"4" title:@"Improvement" color:[UIColor flatGreenSeaColor]],
                [HTLCategoryDto categoryWithIdentifier:@"5" title:@"Recreation" color:[UIColor flatBelizeHoleColor]],
                [HTLCategoryDto categoryWithIdentifier:@"6" title:@"Time Waste" color:[UIColor flatPomegranateColor]]
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

- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSectionDto *)dateSection {
    return [self.storageProvider numberOfCategoriesWithDateSection:dateSection];
}

- (NSArray *)findCategoriesWithDateSection:(HTLDateSectionDto *)dateSection {
    return [self.storageProvider findCategoriesWithDateSection:dateSection];
}

- (BOOL)storeCategory:(HTLCategoryDto *)category {
    return [self.storageProvider storeCategory:category];
}

- (NSArray *)findCompletionsWithText:(NSString *)text {
    return [self.storageProvider findCompletionsWithText:text];
}

- (NSUInteger)numberOfReportSections {
    return [self.storageProvider numberOfReportSections];
}

- (NSArray *)findAllReportSections {
    return [self.storageProvider findAllReportSections];
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSectionDto *)dateSection {
    return [self.storageProvider numberOfReportsWithDateSection:dateSection];
}

- (NSArray *)findReportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection category:(HTLCategoryDto *)category {
    return [self.storageProvider findReportsExtendedWithDateSection:dateSection category:category];
}

- (BOOL)storeReportExtended:(HTLReportExtendedDto *)reportExtended {
    return [self.storageProvider storeReportExtended:reportExtended];
}

- (NSString *)exportDataToCSV {
    return [self.csvStringExportProvider exportReportsExtended:[self.storageProvider findReportsExtendedWithDateSection:nil category:nil]];
}

- (NSDate *)findLastReportEndDate {
    // TODO: If nil == [self.storageProvider findLastReportEndDate] return app launch date
    NSDate *date = [self.storageProvider findLastReportEndDate];
    if (!date) {
        date = self.launchDate;
    }
    return date;
}

- (HTLReportExtendedDto *)findLastReportExtended {
    return [self.storageProvider findLastReportExtended];
}

@end