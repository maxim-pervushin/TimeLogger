//
// Created by Maxim Pervushin on 12/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLJsonStorageProvider.h"
#import "HTLMark.h"
#import "HTLReport.h"
#import "NSDate+HTLComponents.h"
#import "HTLDateSection.h"
#import "HTLStatisticsItem.h"
#import "HexColor.h"
#import "DTFolderMonitor.h"


@interface HTLJsonStorageProvider () {
    NSMutableSet *_marks;
    NSMutableDictionary *_reportsById;
    NSDate *_launchDate;
    NSURL *_storageFolderURL;
    NSString *_storageFileName;
    DTFolderMonitor *_folderMonitor;
}

@end

@implementation HTLJsonStorageProvider

#pragma mark HTLJsonStorageProvider

+ (instancetype)jsonStorageProviderWithStorageFolderURL:(NSURL *)storageFolderURL storageFileName:(NSString *)storageFileName {
    return [[self alloc] initWithStorageFolderURL:storageFolderURL storageFileName:storageFileName];
}

- (instancetype)initWithStorageFolderURL:(NSURL *)storageFolderURL storageFileName:(NSString *)storageFileName {
    self = [super init];
    if (self) {
        _storageFolderURL = [storageFolderURL copy];
        _storageFileName = [storageFileName copy];

        __weak __typeof(self) weakSelf = self;
        _folderMonitor = [DTFolderMonitor folderMonitorForURL:_storageFolderURL block:^{
            [weakSelf restore];
        }];
        [_folderMonitor startMonitoring];

        [self restore];
    }
    return self;
}

- (NSString *)storageFilePath {
    return [_storageFolderURL URLByAppendingPathComponent:_storageFileName].path;
}

- (BOOL)store {
    NSMutableArray *packedMarks = [NSMutableArray new];
    for (HTLMark *mark in _marks) {
        [packedMarks addObject:[self packMark:mark]];
    }

    NSMutableArray *packedReports = [NSMutableArray new];
    for (HTLReport *report in _reportsById.allValues) {
        [packedReports addObject:[self packReport:report]];
    }

    NSDictionary *data = @{
            @"marks" : packedMarks,
            @"reports" : packedReports
    };

    BOOL result = [data writeToFile:[self storageFilePath] atomically:NO];
    if (result) {
        [self changed];
    }
    return result;
}

- (void)restore {
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:[self storageFilePath]];
    NSArray *packedMarks = data[@"marks"];
    NSMutableSet *unpackedMarks = [NSMutableSet new];
    for (NSDictionary *packedMark in packedMarks) {
        [unpackedMarks addObject:[self unpackMark:packedMark]];
    }

    NSArray *packedReports = data[@"reports"];
    NSMutableDictionary *unpackedReportsById = [NSMutableDictionary new];
    for (NSDictionary *packedReport in packedReports) {
        HTLReport *report = [self unpackReport:packedReport];
        unpackedReportsById[report.identifier] = report;
    }

    _marks = unpackedMarks;
    _reportsById = unpackedReportsById;

    [self changed];
}

#pragma mark Pack/Unpack

- (NSDictionary *)packMark:(HTLMark *)mark {
    return @{
            @"title" : mark.title.length > 0 ? mark.title : @"",
            @"subtitle" : mark.subtitle.length > 0 ? mark.subtitle : @"",
            @"color" : mark.color != nil ? [UIColor hexStringFromRGBColor:mark.color] : [UIColor hexStringFromRGBColor:[UIColor blackColor]]
    };
}

- (HTLMark *)unpackMark:(NSDictionary *)dictionary {
    return [HTLMark markWithTitle:dictionary[@"title"] subTitle:dictionary[@"subtitle"] color:[UIColor colorWithHexString:dictionary[@"color"]]];
}

- (NSDictionary *)packReport:(HTLReport *)report {

    NSString *startDateString;
    NSString *startTimeString;
    NSString *startTimeZoneString;
    [report.startDate getDateString:&startDateString timeString:&startTimeString timeZoneString:&startTimeZoneString];

    NSString *endDateString;
    NSString *endTimeString;
    NSString *endTimeZoneString;
    [report.endDate getDateString:&endDateString timeString:&endTimeString timeZoneString:&endTimeZoneString];

    return @{
            @"identifier" : report.identifier.length > 0 ? report.identifier : @"",
            @"mark" : [self packMark:report.mark],
            @"startDate" : startDateString,
            @"startTime" : startTimeString,
            @"startTimeZone" : startTimeZoneString,
            @"endDate" : endDateString,
            @"endTime" : endTimeString,
            @"endTimeZone" : endTimeZoneString
    };
}

- (HTLReport *)unpackReport:(NSDictionary *)dictionary {
    NSDate *startDate = [NSDate dateWithDateString:dictionary[@"startDate"]
                                        timeString:dictionary[@"startTime"]
                                    timeZoneString:dictionary[@"startTimeZone"]];

    NSDate *endDate = [NSDate dateWithDateString:dictionary[@"endDate"]
                                      timeString:dictionary[@"endTime"]
                                  timeZoneString:dictionary[@"endTimeZone"]];

    HTLMark *mark = [self unpackMark:dictionary[@"mark"]];

    return [HTLReport reportWithIdentifier:dictionary[@"identifier"] mark:mark startDate:startDate endDate:endDate];
}

- (void)changed {
    [self.changesObserver changed:self];
}

#pragma mark <HTLStorageProvider>

- (BOOL)clear {
    [_marks removeAllObjects];
    [_reportsById removeAllObjects];
    [self store];
    return YES;
}

- (NSArray *)mandatoryMarks {
    return @[
            [HTLMark markWithTitle:@"Sleep" subTitle:@"" color:[UIColor paperColorDeepPurple]],
            [HTLMark markWithTitle:@"Personal" subTitle:@"" color:[UIColor paperColorIndigo]],
            [HTLMark markWithTitle:@"Road" subTitle:@"" color:[UIColor paperColorRed]],
            [HTLMark markWithTitle:@"Work" subTitle:@"" color:[UIColor paperColorLightGreen]],
            [HTLMark markWithTitle:@"Improvement" subTitle:@"" color:[UIColor paperColorDeepOrange]],
            [HTLMark markWithTitle:@"Recreation" subTitle:@"" color:[UIColor paperColorCyan]],
            [HTLMark markWithTitle:@"Time Waste" subTitle:@"" color:[UIColor paperColorBrown]]
    ];
}

- (NSArray *)customMarks {
    return [_marks sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
}

- (BOOL)saveMark:(HTLMark *)mark {
    [_marks addObject:mark];
    [self store];
    return YES;
}

- (BOOL)deleteMark:(HTLMark *)mark {
    if (![_marks containsObject:mark]) {
        return NO;
    }
    [_marks removeObject:mark];
    [self store];
    return YES;
}

- (NSUInteger)numberOfDateSections {
    return [self dateSections].count;
}

- (NSArray *)dateSections {
    NSMutableSet *dateSections = [NSMutableSet new];
    for (HTLReport *report in _reportsById.allValues) {
        NSString *dateString;
        NSString *timeString;
        NSString *timeZoneString;
        [report.endDate getDateString:&dateString timeString:&timeString timeZoneString:&timeZoneString];
        [dateSections addObject:[HTLDateSection dateSectionWithDateString:dateString timeString:@"" timeZone:@""]];
    }

    return [dateSections sortedArrayUsingDescriptors:@[]];
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection {
    return [self reportsWithDateSection:dateSection mark:nil].count;
}

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection mark:(HTLMark *)mark {
    NSArray *filtered = [_reportsById.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HTLReport *report, NSDictionary *bindings) {
        if (mark && ![mark isEqual:report.mark]) {
            return NO;
        }

        if (dateSection) {
            NSString *dateString;
            NSString *timeString;
            NSString *timeZoneString;
            [report.endDate getDateString:&dateString timeString:&timeString timeZoneString:&timeZoneString];
            if (![dateString isEqual:dateSection.dateString]) {
                return NO;
            }
        }

        return YES;
    }]];

    NSArray *sorted = [filtered sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES]]];

    return sorted;
}

- (BOOL)saveReport:(HTLReport *)report {
    if (!report || !report.mark) {
        return NO;
    }
    if (![[self mandatoryMarks] containsObject:report.mark]) {
        [_marks addObject:report.mark];
    }
    _reportsById[report.identifier] = report;
    [self store];
    return YES;
}

- (NSDate *)lastReportEndDate {
    HTLReport *lastReport = [self lastReport];
    if (lastReport) {
        return lastReport.endDate;
    }
    return _launchDate;
}

- (HTLReport *)lastReport {
    return [[_reportsById.allValues sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES]]] lastObject];
}

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection {
    NSMutableArray *statistics = [NSMutableArray new];
    for (HTLMark *activity in self.mandatoryMarks) {
        [statistics addObject:
                [HTLStatisticsItem statisticsItemWithMark:activity totalTime:arc4random() % 72000 totalReports:arc4random() % 12]];
    }
    for (HTLMark *activity in self.customMarks) {
        [statistics addObject:
                [HTLStatisticsItem statisticsItemWithMark:activity totalTime:arc4random() % 72000 totalReports:arc4random() % 12]];
    }
    return [statistics copy];
}

@end


@implementation HTLMemoryCacheProvider {
    NSCache *_cache;
}

#pragma mark HTLMemoryCacheProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [NSCache new];
    }
    return self;
}

#pragma mark <HTLStorageProvider>

- (BOOL)clear {
    [_cache removeAllObjects];
    return NO;
}

- (NSArray *)mandatoryMarks {
    return nil;
}

- (NSArray *)customMarks {
    return nil;
}

- (BOOL)saveMark:(HTLMark *)mark {
    return NO;
}

- (BOOL)deleteMark:(HTLMark *)mark {
    return NO;
}

- (NSUInteger)numberOfDateSections {
    return 0;
}

- (NSArray *)dateSections {
    return nil;
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection {
    return 0;
}

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection mark:(HTLMark *)mark {
    return nil;
}

- (BOOL)saveReport:(HTLReport *)report {
    return NO;
}

- (NSDate *)lastReportEndDate {
    return nil;
}

- (HTLReport *)lastReport {
    return nil;
}

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection {
    return nil;
}


@end