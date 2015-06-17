//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListModelController.h"
#import "HTLContentManager.h"
#import "HTLDateSectionDto.h"


@interface HTLReportListModelController ()

@property(nonatomic, copy) HTLModelControllerContentChangedBlock contentChangedBlock;

@end

@implementation HTLReportListModelController
@dynamic reportSections;

#pragma mark - HTLReportListModelController

+ (instancetype)modelControllerWithContentChangedBlock:(HTLModelControllerContentChangedBlock)block {
    HTLReportListModelController *instance = [self new];
    if (block) {
        instance.contentChangedBlock = block;
    }
    return instance;
}

- (NSArray *)reportSections {
    return [[HTLContentManager defaultManager] reportSections];
}

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index {
    HTLDateSectionDto *dateSection = [[HTLContentManager defaultManager] reportSections][(NSUInteger) index];
    NSArray *result = [[HTLContentManager defaultManager] reportsExtendedWithSection:dateSection];
    return result;
}

- (void)subscribe {
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kHTLStorageProviderChangedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (weakSelf.contentChangedBlock) {
            weakSelf.contentChangedBlock();
        }
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


