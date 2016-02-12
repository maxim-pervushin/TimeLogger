//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTodayDataSource.h"
#import "HTLReport.h"
#import "HTLContentManager.h"
#import "HTLAppDelegate.h"


@interface HTLTodayDataSource ()

- (void)subscribe;

- (void)unsubscribe;

@end

@implementation HTLTodayDataSource
@dynamic lastReportEndDate;
@dynamic lastReport;

- (HTLReport *)lastReport {
    return [HTLAppContentManger lastReport];
}

- (NSDate *)lastReportEndDate {
    return [HTLAppContentManger lastReportEndDate];
}

- (NSTimeInterval)currentInterval {
    NSDate *lastReportEndDate = [HTLAppContentManger lastReportEndDate];
    if (!lastReportEndDate) {
        return 0;
    }

    return [[NSDate new] timeIntervalSinceDate:lastReportEndDate];
}

- (NSUInteger)numberOfMarks {
    return HTLAppContentManger.customMarks.count + HTLAppContentManger.mandatoryMarks.count;
}

- (HTLMark *)markAtIndex:(NSInteger)index {
    NSMutableArray *activities = [HTLAppContentManger.customMarks mutableCopy];
    [activities addObjectsFromArray:HTLAppContentManger.mandatoryMarks];
    return activities[(NSUInteger) index];
}

- (BOOL)saveReportWithMarkAtIndex:(NSInteger)index {
    return [self saveReportWithMark:[self markAtIndex:index]];
}

- (BOOL)saveReportWithMark:(HTLMark *)mark {
    if (!mark) {
        return NO;
    }

    NSDate *lastReportEndDate = [HTLAppContentManger lastReportEndDate];
    if (!lastReportEndDate) {
        lastReportEndDate = [NSDate new];
    }

    HTLReport *report = [HTLReport reportWithMark:mark startDate:lastReportEndDate endDate:[NSDate new]];

    return [self saveReport:report];
}

- (BOOL)saveReport:(HTLReport *)report {
    return [HTLAppContentManger saveReport:report];
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
