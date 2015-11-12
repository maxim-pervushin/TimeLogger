//
// Created by Maxim Pervushin on 09/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTETodayDataSource.h"
#import "HTLContentManager.h"
#import "HTLReport.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLMemoryCacheProvider.h"
#import "HTLJsonStorageProvider.h"
#import "HTLMark.h"


static NSString *const kApplicationGroup = @"group.timelogger";
static NSString *const kStorageFileName = @"time_logger_storage.db";
static NSString *const kVersionIdentifierKey = @"VersionIdentifier";


@interface HTETodayDataSource ()

@property(nonatomic, strong) HTLContentManager *contentManager;

- (void)subscribe;

- (void)unsubscribe;

@end;


@implementation HTETodayDataSource
@synthesize contentManager = contentManager_;

#pragma mark - HTETodayModelController

- (HTLReport *)lastReport {
    return [self.contentManager lastReport];
}

- (NSDate *)lastReportEndDate {
    return [self.contentManager lastReportEndDate];
}

- (NSTimeInterval)currentInterval {
    NSDate *lastReportEndDate = [self.contentManager lastReportEndDate];
    if (!lastReportEndDate) {
        return 0;
    }

    return [[NSDate new] timeIntervalSinceDate:lastReportEndDate];
}

- (NSUInteger)numberOfMarks {
    return self.contentManager.customMarks.count + self.contentManager.mandatoryMarks.count;
}

- (HTLMark *)markAtIndex:(NSInteger)index {
    NSMutableArray *activities = [self.contentManager.customMarks mutableCopy];
    [activities addObjectsFromArray:self.contentManager.mandatoryMarks];
    return activities[(NSUInteger) index];
}

- (BOOL)saveReportWithMarkAtIndex:(NSInteger)index {
    return [self saveReportWithMark:[self markAtIndex:index]];
}

- (BOOL)saveReportWithMark:(HTLMark *)mark {
    if (!mark) {
        return NO;
    }

    NSDate *lastReportEndDate = [self.contentManager lastReportEndDate];
    if (!lastReportEndDate) {
        lastReportEndDate = [NSDate new];
    }

    HTLReport *report = [HTLReport reportWithMark:mark startDate:lastReportEndDate endDate:[NSDate new]];

    return [self saveReport:report];
}

- (BOOL)saveReport:(HTLReport *)report {
    return [self.contentManager saveReport:report];
}

- (void)subscribe {
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:[HTLContentManager changedNotification] object:nil queue:nil usingBlock:^(NSNotification *note) {
        [weakSelf dataChanged];
    }];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[HTLContentManager changedNotification] object:nil];
};

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kVersionIdentifierKey];
}

- (void)initializeContentManager {
    NSString *applicationGroup = [NSString stringWithFormat:@"%@%@", kApplicationGroup, [self.appVersion isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"-%@", self.appVersion]];

    NSURL *storageFolderURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:applicationGroup];

    HTLJsonStorageProvider *storageProvider = [HTLJsonStorageProvider jsonStorageProviderWithStorageFolderURL:storageFolderURL storageFileName:kStorageFileName];

    HTLMemoryCacheProvider *cacheProvider = [HTLMemoryCacheProvider memoryCacheProviderWithStorageProvider:storageProvider];

    storageProvider.changesObserver = cacheProvider;

    self.contentManager = [HTLContentManager contentManagerWithStorageProvider:cacheProvider exportProvider:[HTLCSVStringExportProvider new]];

    cacheProvider.changesObserver = self.contentManager;
}

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
//        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"VersionIdentifier"];
//        NSString *applicationGroup = [NSString stringWithFormat:@"%@%@", kApplicationGroup, [appVersion isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"-%@", appVersion]];
//
//        NSURL *storageFolderURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:applicationGroup];
//        HTLSqliteStorageProvider *sqliteStorageProvider =
//                [HTLSqliteStorageProvider sqliteStorageProviderWithStorageFolderURL:storageFolderURL
//                                                                    storageFileName:kStorageFileName];
//        contentManager_ = [HTLContentManager contentManagerWithStorageProvider:sqliteStorageProvider exportProvider:[HTLCSVStringExportProvider new]];
        [self initializeContentManager];
        [self subscribe];
    }
    return self;
}

- (void)dealloc {
    [self unsubscribe];
}

@end