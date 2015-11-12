//
// Created by Maxim Pervushin on 12/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//


#import "HTLMemoryCacheProvider.h"
#import "HTLDateSection.h"
#import "HTLReport.h"

@implementation HTLMemoryCacheProvider {
    NSCache *_marksCache;
    NSCache *_reportsCache;
    id <HTLStorageProvider> _storageProvider;
}

#pragma mark HTLMemoryCacheProvider

+ (instancetype)memoryCacheProviderWithStorageProvider:(id <HTLStorageProvider>)storageProvider {
    return [[self alloc] initWithStorageProvider:storageProvider];
}

- (instancetype)initWithStorageProvider:(id <HTLStorageProvider>)storageProvider {
    self = [super init];
    if (self) {
        _marksCache = [NSCache new];
        _reportsCache = [NSCache new];
        _storageProvider = storageProvider;
    }
    return self;
}

#pragma mark <HTLStorageProvider>

- (BOOL)clear {
    [_marksCache removeAllObjects];
    [_reportsCache removeAllObjects];
    return [_storageProvider clear];
}

- (NSArray *)mandatoryMarks {
    NSString *key = NSStringFromSelector(_cmd);
    NSArray *cached = [_marksCache objectForKey:key];
    if (cached) {
        return cached;
    }
    NSArray *result = [_storageProvider mandatoryMarks];
    [_marksCache setObject:result forKey:key];
    return result;
}

- (NSArray *)customMarks {
    NSString *key = NSStringFromSelector(_cmd);
    NSArray *cached = [_marksCache objectForKey:key];
    if (cached) {
        return cached;
    }
    NSArray *result = [_storageProvider customMarks];
    [_marksCache setObject:result forKey:key];
    return result;
}

- (BOOL)saveMark:(HTLMark *)mark {
    BOOL result = [_storageProvider saveMark:mark];
    if (result) {
        [_marksCache removeAllObjects];
    }
    return result;
}

- (BOOL)deleteMark:(HTLMark *)mark {
    BOOL result = [_storageProvider deleteMark:mark];
    if (result) {
        [_marksCache removeAllObjects];
    }
    return result;
}

- (NSUInteger)numberOfDateSections {
    return [self dateSections].count;
}

- (NSArray *)dateSections {
    NSString *key = NSStringFromSelector(_cmd);
    NSArray *cached = [_reportsCache objectForKey:key];
    if (cached) {
        return cached;
    }
    NSArray *result = [_storageProvider dateSections];
    [_reportsCache setObject:result forKey:key];
    return result;
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection {
    NSString *key = [NSString stringWithFormat:@"%@_%@",
                                               NSStringFromSelector(_cmd),
                                               dateSection ? @(dateSection.hash) : @""];
    NSNumber *cached = [_reportsCache objectForKey:key];
    if (cached) {
        return cached.unsignedIntegerValue;
    }
    NSUInteger result = [_storageProvider numberOfReportsWithDateSection:dateSection];
    [_reportsCache setObject:@(result) forKey:key];
    return result;
}

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection mark:(HTLMark *)mark {
    NSString *key = [NSString stringWithFormat:@"%@_%@_%@",
                                               NSStringFromSelector(_cmd),
                                               dateSection ? @(dateSection.hash) : @"",
                                               mark ? @(mark.hash) : @""];
    NSArray *cached = [_reportsCache objectForKey:key];
    if (cached) {
        return cached;
    }
    NSArray *result = [_storageProvider reportsWithDateSection:dateSection mark:mark];
    [_reportsCache setObject:result forKey:key];
    return result;
}

- (BOOL)saveReport:(HTLReport *)report {
    BOOL result = [_storageProvider saveReport:report];
    if (result) {
        [_reportsCache removeAllObjects];
    }
    return result;
}

- (NSDate *)lastReportEndDate {
    NSString *key = NSStringFromSelector(_cmd);
    NSDate *cached = [_reportsCache objectForKey:key];
    if (cached) {
        return cached;
    }
    NSDate *result = [_storageProvider lastReportEndDate];
    [_reportsCache setObject:result forKey:key];
    return result;
}

- (HTLReport *)lastReport {
    NSString *key = NSStringFromSelector(_cmd);
    HTLReport *cached = [_reportsCache objectForKey:key];
    if (cached) {
        return cached;
    }
    HTLReport *result = [_storageProvider lastReport];
    [_reportsCache setObject:result forKey:key];
    return result;
}

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection {
    NSString *key = [NSString stringWithFormat:@"%@_%@",
                                               NSStringFromSelector(_cmd),
                                               dateSection ? @(dateSection.hash) : @""];
    NSArray *cached = [_reportsCache objectForKey:key];
    if (cached) {
        return cached;
    }
    NSArray *result = [_storageProvider statisticsWithDateSection:dateSection];
    [_reportsCache setObject:result forKey:key];
    return result;
}

#pragma mark <HTLChangesObserver>

- (void)observableChanged:(id)observable {
    [_marksCache removeAllObjects];
    [_reportsCache removeAllObjects];
    [self.changesObserver observableChanged:self];
}

@end