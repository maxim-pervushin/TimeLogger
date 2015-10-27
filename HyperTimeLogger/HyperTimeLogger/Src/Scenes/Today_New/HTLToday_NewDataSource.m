//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLToday_NewDataSource.h"
#import "HTLReport.h"
#import "HTLContentManager.h"
#import "HTLAppDelegate.h"


@interface HTLToday_NewDataSource ()

- (void)subscribe;

- (void)unsubscribe;

@end@implementation HTLToday_NewDataSource

- (NSTimeInterval)currentInterval {
    NSDate *lastReportEndDate = [HTLAppContentManger lastReportEndDate];
    if (!lastReportEndDate) {
        return 0;
    }

    return [[NSDate new] timeIntervalSinceDate:lastReportEndDate];
}

- (NSUInteger)numberOfActivities {
    return HTLAppContentManger.customCategories.count + HTLAppContentManger.mandatoryCategories.count;
}

- (HTLActivity *)activityAtIndex:(NSInteger)index {
    NSMutableArray *activities = [HTLAppContentManger.customCategories mutableCopy];
    [activities addObjectsFromArray:HTLAppContentManger.mandatoryCategories];
    return activities[(NSUInteger) index];
}

- (BOOL)saveReportWithActivityAtIndex:(NSInteger)index {
    return [self saveReportWithActivity:[self activityAtIndex:index]];
}

- (BOOL)saveReportWithActivity:(HTLActivity *)category {
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