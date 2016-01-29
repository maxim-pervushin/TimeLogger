//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListModelController.h"
#import "HTLContentManager.h"
#import "HTLDateSectionDto.h"
#import "HTLAppDelegate.h"


@interface HTLReportListModelController ()

- (void)subscribe;

- (void)unsubscribe;

@end;


@implementation HTLReportListModelController
@dynamic numberOfReportSections;
@dynamic reportSections;
@dynamic startDate;

#pragma mark - HTLReportListModelController

- (NSUInteger)numberOfReportSections {
    return [HTLAppContentManger numberOfReportSections];
}

- (NSArray *)reportSections {
    return [HTLAppContentManger findAllReportSections];
}

- (NSDate *)startDate {
    return [HTLAppContentManger findLastReportEndDate];
}

- (NSUInteger)numberOfReportsForDateSectionAtIndex:(NSInteger)index {
    HTLDateSectionDto *dateSection = self.reportSections[(NSUInteger) index];
    NSUInteger result = [HTLAppContentManger numberOfReportsWithDateSection:dateSection];
    return result;
}

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index {
    HTLDateSectionDto *dateSection = [HTLAppContentManger findAllReportSections][(NSUInteger) index];
    NSArray *result = [HTLAppContentManger findReportsExtendedWithDateSection:dateSection category:nil];
    return result;
}

- (void)subscribe {
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kHTLStorageProviderChangedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [weakSelf contentChanged];
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


