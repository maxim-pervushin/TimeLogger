//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTodayDataSource.h"
#import "HTLCategory.h"
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

- (NSUInteger)numberOfCategories {
    return [HTLAppContentManger numberOfCategoriesWithDateSection:nil];
}

- (HTLCategory *)categoryAtIndexPath:(NSIndexPath *)indexPath {

    return [HTLAppContentManger categoriesWithDateSection:nil][(NSUInteger) indexPath.row];
}

- (BOOL)saveReportWithCategoryAtIndexPath:(NSIndexPath *)indexPath {
    HTLCategory *category = [self categoryAtIndexPath:indexPath];
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
