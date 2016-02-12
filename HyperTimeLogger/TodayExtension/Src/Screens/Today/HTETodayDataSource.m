//
// Created by Maxim Pervushin on 09/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTETodayDataSource.h"
#import "HTLDataManager.h"
#import "HTLReportExtended.h"
#import "HTLCompletion.h"
#import "HTLCategory.h"
#import "HTLAction.h"
#import "HTLReport.h"
#import "HTLAppDelegate.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLSqliteStorageProvider.h"


static NSString *const kApplicationGroup = @"group.timelogger";
static NSString *const kStorageFileName = @"time_logger_storage.db";


@interface HTETodayDataSource ()

@property(nonatomic, strong) HTLDataManager *contentManager;

- (void)subscribe;

- (void)unsubscribe;

@end;


@implementation HTETodayDataSource
@synthesize contentManager = contentManager_;

#pragma mark - HTETodayDataSource

- (NSArray *)completions:(NSUInteger)numberOfCompletions {
    NSArray *completions = [self.contentManager findCompletionsWithText:nil];
    NSMutableArray *result = [NSMutableArray new];
    for (NSUInteger i = 0; i < completions.count && i < numberOfCompletions; i++) {
        [result addObject:completions[i]];
    }
    return [result copy];
}

- (BOOL)createReportWithCompletion:(HTLCompletion *)completion {
    NSDate *startDate = self.contentManager.findLastReportEndDate;
    HTLReport *report = [HTLReport reportWithIdentifier:[NSUUID UUID].UUIDString
                                       actionIdentifier:completion.action.identifier
                                     categoryIdentifier:completion.category.identifier
                                              startDate:startDate ? startDate : [NSDate new]
                                                endDate:[NSDate new]];
    HTLReportExtended *reportExtended =
            [HTLReportExtended reportExtendedWithReport:report action:completion.action category:completion.category];

    return [self.contentManager storeReportExtended:reportExtended];
}

- (HTLReportExtended *)lastReportExtended {
    return self.contentManager.findLastReportExtended;
}

- (void)subscribe {
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kHTLStorageProviderChangedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [weakSelf dataChanged];
    }];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHTLStorageProviderChangedNotification object:nil];
};

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"VersionIdentifier"];
        NSString *applicationGroup = [NSString stringWithFormat:@"%@%@", kApplicationGroup, [appVersion isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"-%@", appVersion]];

        NSURL *storageFolderURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:applicationGroup];
        HTLSqliteStorageProvider *sqliteStorageProvider =
                [HTLSqliteStorageProvider sqliteStorageProviderWithStorageFolderURL:storageFolderURL
                                                                    storageFileName:kStorageFileName];
        contentManager_ = [HTLDataManager contentManagerWithStorageProvider:sqliteStorageProvider exportProvider:[HTLCSVStringExportProvider new]];
        [self subscribe];
    }
    return self;
}

- (void)dealloc {
    [self unsubscribe];
}

@end