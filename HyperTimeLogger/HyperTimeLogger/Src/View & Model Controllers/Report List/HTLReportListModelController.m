//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListModelController.h"
#import "HTLContentManager.h"
#import "HTLDateSectionDto.h"


@interface HTLReportListModelController ()

- (void)subscribe;

- (void)unsubscribe;

@end;


@implementation HTLReportListModelController
@dynamic numberOfReportSections;
@dynamic reportSections;

#pragma mark - HTLReportListModelController

- (NSUInteger)numberOfReportSections {
    return [[HTLContentManager defaultManager] numberOfCategoriesWithDateSection:nil];
}

- (NSArray *)reportSections {
    return [[HTLContentManager defaultManager] reportSections];
}

- (NSUInteger)countOfReportsForDateSectionAtIndex:(NSInteger)index {
    HTLDateSectionDto *dateSection = [[HTLContentManager defaultManager] reportSections][(NSUInteger) index];
    NSUInteger result = [[HTLContentManager defaultManager] numberOfReportsWithDateSection:dateSection];
    return result;
}

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index {
    HTLDateSectionDto *dateSection = [[HTLContentManager defaultManager] reportSections][(NSUInteger) index];
    NSArray *result = [[HTLContentManager defaultManager] findReportsExtendedWithDateSection:dateSection category:nil];
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


