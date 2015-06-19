//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsModelController.h"
#import "HTLReportDto.h"
#import "HTLReportExtendedDto.h"
#import "HTLContentManager.h"
#import "HTLDateSectionDto.h"
#import "HTLStatisticsItemDto.h"


@interface HTLStatisticsModelController ()

- (void)subscribe;

- (void)unsubscribe;

@end


@implementation HTLStatisticsModelController
@dynamic categories;

#pragma mark - HTLStatisticsModelController

+ (instancetype)modelControllerWithDateSection:(HTLDateSectionDto *)dateSection contentChangedBlock:(HTLModelControllerContentChangedBlock)block {

    HTLStatisticsModelController *instance = [self modelControllerWithContentChangedBlock:block];
    instance.dateSection = dateSection;
    return instance;
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


- (NSArray *)categories {
    return [[HTLContentManager defaultManager] findCategoriesWithDateSection:self.dateSection];
}

- (HTLStatisticsItemDto *)statisticsForCategory:(HTLCategoryDto *)category {
    NSArray *reportsExtended = [[HTLContentManager defaultManager] findReportsExtendedWithDateSection:self.dateSection
                                                                                             category:category];

    NSTimeInterval totalTime = 0;
    NSUInteger totalReports = 0;
    for (HTLReportExtendedDto *reportExtended in reportsExtended) {
        totalTime += [reportExtended.report.endDate timeIntervalSinceDate:reportExtended.report.startDate];
        totalReports++;
    }

    return [HTLStatisticsItemDto statisticsItemWithCategory:category totalTime:totalTime totalReports:totalReports];
}

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