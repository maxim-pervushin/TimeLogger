//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTodayDataSource.h"
#import "HTLActivity.h"
#import "HTLAppDelegate.h"
#import "HTLContentManager.h"
#import "HTLReport.h"


@interface HTLTodayDataSource ()

- (void)subscribe;

- (void)unsubscribe;

@end

@implementation HTLTodayDataSource

- (NSTimeInterval)currentInterval {
    NSDate *lastReportEndDate = [HTLAppContentManger lastReportEndDate];
    if (!lastReportEndDate) {
        return 0;
    }

    return [[NSDate new] timeIntervalSinceDate:lastReportEndDate];
}

- (NSUInteger)numberOfMandatoryCategories {
    return HTLAppContentManger.mandatoryCategories.count;
}

- (NSUInteger)numberOfCustomCategories {
    return HTLAppContentManger.customCategories.count;
}

- (HTLActivity *)mandatoryCategoryAtIndex:(NSInteger)index {
    return HTLAppContentManger.mandatoryCategories[(NSUInteger) index];
}

- (HTLActivity *)customCategoryAtIndex:(NSInteger)index {
    return HTLAppContentManger.customCategories[(NSUInteger) index];
}

- (BOOL)saveReportWithMandatoryCategoryAtIndex:(NSInteger)index {
    return [self saveReportWithCategory:[self mandatoryCategoryAtIndex:index]];
}

- (BOOL)saveReportWithCustomCategoryAtIndex:(NSInteger)index {
    return [self saveReportWithCategory:[self customCategoryAtIndex:index]];
}

- (BOOL)saveReportWithCategory:(HTLActivity *)category {
    if (!category) {
        return NO;
    }

    NSDate *lastReportEndDate = [HTLAppContentManger lastReportEndDate];
    if (!lastReportEndDate) {
        lastReportEndDate = [NSDate new];
    }

    HTLReport *report = [HTLReport reportWithCategory:category startDate:lastReportEndDate endDate:[NSDate new]];

    return [HTLAppContentManger saveReport:report];
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
