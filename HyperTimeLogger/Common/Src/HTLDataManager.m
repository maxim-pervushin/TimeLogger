//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataManager.h"
#import "HTLReport.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLReportExtended.h"
#import "HTLDateSection.h"
#import "UIColor+FlatColors.h"

@interface HTLDataManager ()

@property(nonatomic, strong) id <HTLStorageProvider> storageProvider;
@property(nonatomic, strong) HTLCSVStringExportProvider *csvStringExportProvider;
@property(nonatomic, strong) NSDate *launchDate;
@property(nonatomic, strong) NSString *launchVersion;

- (void)initializeLaunchDate;

- (void)initializeLaunchVersion;

- (void)initializeStorage;

@end

@implementation HTLDataManager

+ (instancetype)contentManagerWithStorageProvider:(id <HTLStorageProvider>)storageProvider exportProvider:(id <HTLStringExportProvider>)exportProvider {
    HTLDataManager *contentManager = [HTLDataManager new];
    contentManager.storageProvider = storageProvider;
    contentManager.csvStringExportProvider = exportProvider;
    [contentManager initializeLaunchDate];
    [contentManager initializeLaunchVersion];
    return contentManager;
}

- (void)initializeLaunchDate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [defaults objectForKey:@"launchDate"];
    if (!date) {
        date = [NSDate new];
        [defaults setObject:date forKey:@"launchDate"];
        [defaults synchronize];
    }
    self.launchDate = date;
}

- (void)initializeLaunchVersion {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *launchVersion = [defaults objectForKey:@"launchVersion"];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    if (![launchVersion isEqualToString:currentVersion]) {
        launchVersion = currentVersion;
        [defaults setObject:launchVersion forKey:@"launchVersion"];
        [defaults synchronize];
        [self initializeStorage];
    }
    self.launchVersion = launchVersion;
}

- (void)initializeStorage {
    NSArray *initialCategories = @[
            [HTLCategory categoryWithIdentifier:@"0" title:@"Sleep" color:[UIColor flatMidnightBlueColor]],
            [HTLCategory categoryWithIdentifier:@"1" title:@"Personal" color:[UIColor flatPumpkinColor]],
            [HTLCategory categoryWithIdentifier:@"2" title:@"Road" color:[UIColor flatWisteriaColor]],
            [HTLCategory categoryWithIdentifier:@"3" title:@"Work" color:[UIColor flatNephritisColor]],
            [HTLCategory categoryWithIdentifier:@"4" title:@"Improvement" color:[UIColor flatGreenSeaColor]],
            [HTLCategory categoryWithIdentifier:@"5" title:@"Recreation" color:[UIColor flatBelizeHoleColor]],
            [HTLCategory categoryWithIdentifier:@"6" title:@"Time Waste" color:[UIColor flatPomegranateColor]]
    ];

    for (HTLCategory *category in initialCategories) {
        [self.storageProvider storeCategory:category];
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

- (NSArray *)findCategoriesWithDateSection:(HTLDateSection *)dateSection {
    return [self.storageProvider findCategoriesWithDateSection:dateSection];
}

- (BOOL)storeCategory:(HTLCategory *)category {
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

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection {
    return [self.storageProvider numberOfReportsWithDateSection:dateSection];
}

- (NSArray *)findReportsExtendedWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category {
    return [self.storageProvider findReportsExtendedWithDateSection:dateSection category:category];
}

- (BOOL)storeReportExtended:(HTLReportExtended *)reportExtended {
    return [self.storageProvider storeReportExtended:reportExtended];
}

- (NSString *)exportDataToCSV {
    return [self.csvStringExportProvider exportReportsExtended:[self.storageProvider findReportsExtendedWithDateSection:nil category:nil]];
}

- (NSDate *)findLastReportEndDate {
    NSDate *date = [self.storageProvider findLastReportEndDate];
    if (!date) {
        date = self.launchDate;
    }
    return date;
}

- (HTLReportExtended *)findLastReportExtended {
    return [self.storageProvider findLastReportExtended];
}

@end