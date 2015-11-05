//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStorageProvider.h"
#import "HTLContentManager.h"
#import "HTLReport.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLDateSection.h"


static NSString *const kChangedNotification = @"HTLContentManagerChangedNotification";

@interface HTLContentManager ()

@property(nonatomic, strong) id <HTLStorageProvider> storageProvider;
@property(nonatomic, strong) HTLCSVStringExportProvider *csvStringExportProvider;

@end

@implementation HTLContentManager

+ (NSString *)changedNotification {
    return kChangedNotification;
}

+ (instancetype)contentManagerWithStorageProvider:(id <HTLStorageProvider>)storageProvider exportProvider:(id <HTLStringExportProvider>)exportProvider {
    HTLContentManager *contentManager = [HTLContentManager new];
    contentManager.storageProvider = storageProvider;
    contentManager.csvStringExportProvider = exportProvider;
    return contentManager;
}

- (BOOL)clear {
    BOOL result = [self.storageProvider clear];
    return result;
}

- (NSArray *)mandatoryMarks {
    return self.storageProvider.mandatoryMarks;
}

- (NSArray *)customMarks {
    return self.storageProvider.customMarks;
}

- (BOOL)saveMark:(HTLMark *)mark {
    return [self.storageProvider saveMark:mark];
}

- (BOOL)deleteMark:(HTLMark *)mark {
    return [self.storageProvider deleteMark:mark];
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

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection mark:(HTLMark *)mark {
    return [self.storageProvider reportsWithDateSection:dateSection mark:mark];
}

- (BOOL)saveReport:(HTLReport *)report {
    return [self.storageProvider saveReport:report];
}

- (NSString *)exportDataToCSV {
    return [self.csvStringExportProvider exportReportsExtended:[self.storageProvider reportsWithDateSection:nil mark:nil]];
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

#pragma mark - HTLChangesObserver

- (void)changed:(id)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:[self.class changedNotification] object:self];
}

@end