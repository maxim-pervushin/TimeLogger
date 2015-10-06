//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListDataSource.h"
#import "HTLDateSection.h"
#import "HTLReportExtended.h"
#import "HTLAppDelegate.h"
#import "HTLContentManager.h"


@interface HTLReportListDataSource ()

@property(nonatomic, strong) NSArray *dateSections;
@property(nonatomic, assign) NSUInteger currentDateSectionIndex;

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

- (HTLReportExtended *)reportAtIndexPath:(NSIndexPath *)indexPath {
    return [HTLAppContentManger reportsExtendedWithDateSection:self.selectedDateSection category:nil][(NSUInteger) indexPath.row];
}

- (void)reloadData {
    BOOL resetIndex = NO;
    if (!self.dateSections) {
        resetIndex = YES;
    }
    self.dateSections = [HTLAppContentManger reportSections];
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
