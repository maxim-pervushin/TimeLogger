//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListDataSource.h"
#import "HTLDataManager.h"
#import "HTLDateSection.h"
#import "HTLAppDelegate.h"


@interface HTLReportListDataSource ()

- (void)subscribe;

- (void)unsubscribe;

@end;


@implementation HTLReportListDataSource
@dynamic numberOfReportSections;
@dynamic reportSections;
@dynamic startDate;

#pragma mark - HTLReportListDataSource

- (NSUInteger)numberOfReportSections {
    return [HTLAppDataManger numberOfReportSections];
}

- (NSArray *)reportSections {
    return [HTLAppDataManger findAllReportSections];
}

- (NSDate *)startDate {
    return [HTLAppDataManger findLastReportEndDate];
}

- (NSUInteger)numberOfReportsForDateSectionAtIndex:(NSInteger)index {
    HTLDateSection *dateSection = self.reportSections[(NSUInteger) index];
    NSUInteger result = [HTLAppDataManger numberOfReportsWithDateSection:dateSection];
    return result;
}

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index {
    HTLDateSection *dateSection = [HTLAppDataManger findAllReportSections][(NSUInteger) index];
    NSArray *result = [HTLAppDataManger findReportsExtendedWithDateSection:dateSection category:nil];
    return result;
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
        [self subscribe];
    }
    return self;
}

- (void)dealloc {
    [self unsubscribe];
}

@end


