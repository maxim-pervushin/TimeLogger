//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListDataSource.h"
#import "HTLApp.h"
#import "HTLDataManager.h"
#import "HTLDateSection.h"


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
    return [[HTLApp dataManager] numberOfReportSections];
}

- (NSArray *)reportSections {
    return [[HTLApp dataManager] findAllReportSections];
}

- (NSDate *)startDate {
    return [[HTLApp dataManager] findLastReportEndDate];
}

- (NSUInteger)numberOfReportsForDateSectionAtIndex:(NSInteger)index {
    HTLDateSection *dateSection = self.reportSections[(NSUInteger) index];
    NSUInteger result = [[HTLApp dataManager] numberOfReportsWithDateSection:dateSection];
    return result;
}

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index {
    HTLDateSection *dateSection = [[HTLApp dataManager] findAllReportSections][(NSUInteger) index];
    NSArray *result = [[HTLApp dataManager] findReportsExtendedWithDateSection:dateSection category:nil];
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


