//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLTodayDataSource.h"
#import "HTLCategory.h"
#import "HTLAppDelegate.h"
#import "HTLContentManager.h"
#import "HTLReportExtended.h"
#import "HTLAction.h"
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

    HTLAction *action = [HTLAction actionWithIdentifier:[[NSUUID new] UUIDString]
                                                  title:@""];
    HTLReport *report = [HTLReport reportWithIdentifier:[[NSUUID new] UUIDString]
                                       actionIdentifier:action.identifier
                                     categoryIdentifier:category.identifier
                                              startDate:lastReportEndDate ? lastReportEndDate : [NSDate new]
                                                endDate:[NSDate new]];

    HTLReportExtended *reportExtended = [HTLReportExtended reportExtendedWithReport:report
                                                                             action:action
                                                                           category:category];

    return [HTLAppContentManger saveReportExtended:reportExtended];
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
