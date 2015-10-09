//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListDataSource.h"
#import "HTLDateSection.h"
#import "HTLAppDelegate.h"
#import "HTLContentManager.h"
#import "HTLReport.h"


@interface HTLReportListDataSource ()

@property(nonatomic, strong) NSArray *dateSections;
@property(nonatomic, assign) NSUInteger currentDateSectionIndex;
@property(nonatomic, strong) NSArray *statistics;
//@property(nonatomic, strong) NSArray *categoriesSaved;
//@property(nonatomic, strong) NSDictionary *statisticsByCategorySaved;

- (void)reloadData;

- (void)subscribe;

- (void)unsubscribe;

@end

@implementation HTLReportListDataSource

- (void)setSelectedDateSection:(HTLDateSection *)selectedDateSection {
    if (!selectedDateSection) {
        self.currentDateSectionIndex = self.dateSections.count - 1;
        return;
    }

    NSUInteger newCurrentDateSectionIndex = [self.dateSections indexOfObject:selectedDateSection];
    if (newCurrentDateSectionIndex == NSNotFound) {
        self.currentDateSectionIndex = self.dateSections.count - 1;
        return;
    }

    self.currentDateSectionIndex = newCurrentDateSectionIndex;
    [self dataChanged];
}

- (HTLDateSection *)selectedDateSection {
    if (self.dateSections.count <= self.currentDateSectionIndex) {
        return nil;
    }
    return self.dateSections[self.currentDateSectionIndex];
}

- (BOOL)hasPreviousDateSection {
    return self.currentDateSectionIndex > 0;
}

- (BOOL)hasNextDateSection {
    return self.currentDateSectionIndex < self.dateSections.count - 1;
}

- (void)incrementCurrentDateSectionIndex {
    if (self.currentDateSectionIndex < self.dateSections.count - 1) {
        self.currentDateSectionIndex++;
        [self dataChanged];
    }
}

- (void)decrementCurrentDateSectionIndex {
    if (self.currentDateSectionIndex > 0) {
        self.currentDateSectionIndex--;
        [self dataChanged];
    }
}

- (NSUInteger)numberOfReports {
    return [HTLAppContentManger numberOfReportsWithDateSection:self.selectedDateSection];
}

- (HTLReport *)reportAtIndexPath:(NSIndexPath *)indexPath {
    return [HTLAppContentManger reportsWithDateSection:self.selectedDateSection category:nil][(NSUInteger) indexPath.row];
}

- (void)reloadStatistics {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        NSLog(@"Calculating statistics for date section...");
        weakSelf.statistics = [HTLAppContentManger statisticsWithDateSection:weakSelf.selectedDateSection];
        NSLog(@"Done.");

        NSLog(@"Calculating global statistics...");
        [HTLAppContentManger statisticsWithDateSection:nil];
        NSLog(@"Done.");


        //NSLog(@"Statistics: %@", weakSelf.statistics);

//        NSArray *categories = [HTLAppContentManger categoriesWithDateSection:weakSelf.selectedDateSection];
//        NSMutableArray *categoriesCalculated = [NSMutableArray new];
//        NSMutableDictionary *statisticsByCategoryCalculated = [NSMutableDictionary new];
//        NSLog(@"Calculating statistics...");
//        for (HTLActivity *category in categories) {
//            NSArray *reports = [HTLAppContentManger reportsWithDateSection:weakSelf.selectedDateSection
//                                                                  category:category];
//
//            NSTimeInterval totalTime = 0;
//            NSUInteger totalReports = 0;
//            for (HTLReport *report in reports) {
//                totalTime += [report.endDate timeIntervalSinceDate:report.startDate];
//                totalReports++;
//            }
//
//            HTLStatisticsItem *statisticsItem = [HTLStatisticsItem statisticsItemWithCategory:category totalTime:totalTime totalReports:totalReports];
//
//            NSLog(@"%@", statisticsItem);
//
//            if (statisticsItem) {
//                [categoriesCalculated addObject:category];
//                NSString *key = [NSString stringWithFormat:@"%@", @(category.hash)];
//                statisticsByCategoryCalculated[key] = statisticsItem;
//            }
//        }
//
//        weakSelf.categoriesSaved = [categoriesCalculated copy];
//        weakSelf.statisticsByCategorySaved = [statisticsByCategoryCalculated copy];
//
//        NSLog(@"Statistics calculated.");

        [weakSelf dataChanged];
    });
}

- (void)reloadData {
    BOOL resetIndex = NO;
    if (!self.dateSections) {
        resetIndex = YES;
    }
    self.dateSections = [HTLAppContentManger dateSections];
    if (resetIndex || self.currentDateSectionIndex >= self.dateSections.count) {
        self.currentDateSectionIndex = self.dateSections.count - 1;
    }

    [self dataChanged];
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
