//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsDataSource.h"
#import "HTLReportDto.h"
#import "HTLReportExtendedDto.h"
#import "HTLContentManager.h"
#import "HTLDateSectionDto.h"
#import "HTLStatisticsItemDto.h"
#import "HTLAppDelegate.h"


@interface HTLStatisticsDataSource ()      {
    BOOL _loaded;
}

@property (nonatomic, strong) NSArray *categoriesSaved;
@property (nonatomic, assign) NSTimeInterval totalTimeSaved;
@property (nonatomic, strong) NSDictionary *statisticsByCategorySaved;

- (void)subscribe;

- (void)unsubscribe;

@end


@implementation HTLStatisticsDataSource
@dynamic loaded;
@dynamic categories;
@dynamic totalTime;

#pragma mark - HTLStatisticsDataSource

+ (instancetype)dataSourceWithDateSection:(HTLDateSectionDto *)dateSection dataChangedBlock:(HTLDataSourceDataChangedBlock)block {

    HTLStatisticsDataSource *instance = [self dataSourceWithDataChangedBlock:block];
    instance.dateSection = dateSection;
    return instance;
}

- (void)reloadData {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *categories = [HTLAppContentManger findCategoriesWithDateSection:weakSelf.dateSection];
        NSMutableArray *categoriesCalculated = [NSMutableArray new];
        NSMutableDictionary *statisticsByCategoryCalculated = [NSMutableDictionary new];
        NSTimeInterval totalTime = 0;
        for (HTLCategoryDto *category in categories) {
            NSArray *reportsExtended = [HTLAppContentManger findReportsExtendedWithDateSection:self.dateSection
                                                                                                     category:category];

            NSTimeInterval categoryTotalTime = 0;
            NSUInteger totalReports = 0;
            for (HTLReportExtendedDto *reportExtended in reportsExtended) {
                categoryTotalTime += [reportExtended.report.endDate timeIntervalSinceDate:reportExtended.report.startDate];
                totalReports++;
            }
            totalTime += categoryTotalTime;

            HTLStatisticsItemDto *statisticsItem = [HTLStatisticsItemDto statisticsItemWithCategory:category totalTime:categoryTotalTime totalReports:totalReports];
            if (statisticsItem) {
                [categoriesCalculated addObject:category];
                NSString *key = [NSString stringWithFormat:@"%@", @(category.hash)];
                statisticsByCategoryCalculated[key] = statisticsItem;
            }
        }

        weakSelf.categoriesSaved = [categoriesCalculated copy];
        weakSelf.totalTimeSaved = totalTime;
        weakSelf.statisticsByCategorySaved = [statisticsByCategoryCalculated copy];

        _loaded = YES;
        [weakSelf dataChanged];
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

- (BOOL)loaded {
    return _loaded;
}

- (NSArray *)categories {
    return self.categoriesSaved;
}

- (NSTimeInterval)totalTime {
    return self.totalTimeSaved;
}

- (HTLStatisticsItemDto *)statisticsForCategory:(HTLCategoryDto *)category {
    NSString *key = [NSString stringWithFormat:@"%@", @(category.hash)];
    return self.statisticsByCategorySaved[key];
}

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _loaded = NO;
        [self subscribe];
        [self reloadData];
    }
    return self;
}

- (void)dealloc {
    [self unsubscribe];
}

@end