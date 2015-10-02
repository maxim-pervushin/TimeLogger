//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsDataSource.h"
#import "HTLReport.h"
#import "HTLReportExtended.h"
#import "HTLContentManager.h"
#import "HTLDateSection.h"
#import "HTLStatisticsItemDto.h"
#import "HTLAppDelegate.h"


@interface HTLStatisticsDataSource ()

@property (nonatomic, strong) NSArray *categoriesSaved;
@property (nonatomic, strong) NSDictionary *statisticsByCategorySaved;

- (void)subscribe;

- (void)unsubscribe;

@end


@implementation HTLStatisticsDataSource
@dynamic categories;

#pragma mark - HTLStatisticsModelController

+ (instancetype)dataSourceWithDateSection:(HTLDateSection *)dateSection contentChangedBlock:(HTLDataSourceChangedBlock)block {

    HTLStatisticsDataSource *instance = [self dataSourceWithContentChangedBlock:block];
    instance.dateSection = dateSection;
    return instance;
}

- (void)reloadData {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *categories = [HTLAppContentManger categoriesWithDateSection:weakSelf.dateSection];
        NSMutableArray *categoriesCalculated = [NSMutableArray new];
        NSMutableDictionary *statisticsByCategoryCalculated = [NSMutableDictionary new];
        for (HTLCategory *category in categories) {
            NSArray *reportsExtended = [HTLAppContentManger reportsExtendedWithDateSection:self.dateSection
                                                                                  category:category];

            NSTimeInterval totalTime = 0;
            NSUInteger totalReports = 0;
            for (HTLReportExtended *reportExtended in reportsExtended) {
                totalTime += [reportExtended.report.endDate timeIntervalSinceDate:reportExtended.report.startDate];
                totalReports++;
            }

            HTLStatisticsItemDto *statisticsItem = [HTLStatisticsItemDto statisticsItemWithCategory:category totalTime:totalTime totalReports:totalReports];
            if (statisticsItem) {
                [categoriesCalculated addObject:category];
                NSString *key = [NSString stringWithFormat:@"%@", @(category.hash)];
                statisticsByCategoryCalculated[key] = statisticsItem;
            }
        }

        weakSelf.categoriesSaved = [categoriesCalculated copy];
        weakSelf.statisticsByCategorySaved = [statisticsByCategoryCalculated copy];

        [weakSelf contentChanged];
    });
}

- (void)subscribe {
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kHTLStorageProviderChangedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [weakSelf reloadData];
    }];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHTLStorageProviderChangedNotification object:nil];
};


- (NSArray *)categories {
    return self.categoriesSaved;
}

- (HTLStatisticsItemDto *)statisticsForCategory:(HTLCategory *)category {
    NSString *key = [NSString stringWithFormat:@"%@", @(category.hash)];
    return self.statisticsByCategorySaved[key];
}

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        [self subscribe];
        [self reloadData];
    }
    return self;
}

- (void)dealloc {
    [self unsubscribe];
}

@end