//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSqliteStorageProvider.h"
#import "HTLReportExtendedDto.h"
#import "FMDB.h"
#import "HTLCategoryDto.h"
#import "HTLActionDto.h"
#import "HTLCompletionDto.h"
#import "NSDate+HTLComponents.h"
#import "HTLDateSectionDto.h"
#import "DTFolderMonitor.h"
#import "HTLReportDto.h"
#import "HTLSqliteStorageProvider+Deserialization.h"
#import "HTLSqliteStorageProvider+TestData.h"

static NSString *const kApplicationGroup = @"group.timelogger";
static NSString *const kStorageFileName = @"time_logger_storage.db";

static NSString *const kCategoriesCacheKey = @"categories";
static NSString *const kReportSectionsCacheKey = @"reportSections";
static NSString *const kReportsExtendedCacheKey = @"reportsExtended";
static NSString *const kLastReportExtendedCacheKey = @"lastReportExtended";
static NSString *const kLastReportEndDateCacheKey = @"lastReportEndDate";

@interface HTLSqliteStorageProvider ()

@property(nonatomic, strong) NSCache *cache;
@property(nonatomic, strong) NSCache *categoriesBySectionCache;
@property(nonatomic, strong) NSCache *reportsExtendedBySectionCache;
@property(nonatomic, strong) NSCache *reportsExtendedByCategoryAndSectionCache;
@property(nonatomic, strong) NSCache *completionByPatternCache;
@property(nonatomic, strong) DTFolderMonitor *folderMonitor;

@end

@implementation HTLSqliteStorageProvider
@synthesize cache = cache_;
@synthesize categoriesBySectionCache = categoriesBySectionCache_;
@synthesize reportsExtendedBySectionCache = reportsExtendedBySectionCache_;
@synthesize reportsExtendedByCategoryAndSectionCache = reportsExtendedByCategoryAndSectionCache_;
@synthesize completionByPatternCache = completionByPatternCache_;
@synthesize folderMonitor = folderMonitor_;

#pragma mark - HTLSqliteStorageProvider

- (NSURL *)storageFileFolderURL {
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kApplicationGroup];
}

- (NSString *)storageFilePath {
    return [self.storageFileFolderURL URLByAppendingPathComponent:kStorageFileName].path;
}

- (FMDatabase *)databaseOpen {
    [self checkStorage];
    FMDatabase *database = [FMDatabase databaseWithPath:[self storageFilePath]];
    if (![database open]) {
        DDLogError(@"Unable to open database.");
        return nil;
    }
    return database;
}

- (void)checkStorage {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self storageFilePath]]) {
        FMDatabase *database = [FMDatabase databaseWithPath:[self storageFilePath]];
        if (![database open]) {
            DDLogVerbose(@"Error. Unable to open database.");
            return;
        }

        BOOL result = [database executeUpdate:
                @"CREATE TABLE action("
                        "identifier TEXT PRIMARY KEY, "
                        "title TEXT "
                        ");"];

        DDLogVerbose(@"action table created: %@", result ? @"YES" : @"NO");

        result = [database executeUpdate:
                @"CREATE TABLE category("
                        "identifier TEXT PRIMARY KEY, "
                        "title TEXT, "
                        "color TEXT"
                        ");"];

        DDLogVerbose(@"category table created: %@", result ? @"YES" : @"NO");

        result = [database executeUpdate:
                @"CREATE TABLE report("
                        "identifier TEXT PRIMARY KEY, "
                        "actionIdentifier TEXT, "
                        "categoryIdentifier TEXT, "
                        "startDate REAL, "
                        "startTime REAL, "
                        "startZone TEXT, "
                        "endDate REAL, "
                        "endTime REAL, "
                        "endZone TEXT"
                        ");"];

        DDLogVerbose(@"report table created: %@", result ? @"YES" : @"NO");

        [database close];
    }

    [self createTestData];
}

- (void)clearCaches {
    [self.cache removeAllObjects];
    [self.categoriesBySectionCache removeAllObjects];
    [self.reportsExtendedBySectionCache removeAllObjects];
    [self.reportsExtendedByCategoryAndSectionCache removeAllObjects];
    [self.completionByPatternCache removeAllObjects];
}

#pragma mark - DB

- (NSArray *)categoriesInDatabase:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:@"SELECT "
            "category.identifier AS categoryIdentifier, "
            "category.title AS categoryTitle, "
            "category.color AS categoryColor "
            "FROM category "
            "ORDER BY identifier;"];

    NSMutableArray *categories = [NSMutableArray new];
    while ([resultSet next]) {
        HTLCategoryDto *category = [self categoryWithResultSet:resultSet];
        if (category) {
            [categories addObject:category];
        }
    }
    [resultSet close];

    return [categories copy];
}

- (NSArray *)categoriesWithDateSection:(HTLDateSectionDto *)dateSection database:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:
                    @"SELECT "
                            "category.identifier AS categoryIdentifier, "
                            "category.title AS categoryTitle, "
                            "category.color AS categoryColor "
                            "FROM category "
                            "INNER JOIN report ON report.categoryIdentifier = category.identifier "
                            "WHERE report.endDate = :endDate "
                            "GROUP BY category.identifier "
                            "ORDER BY category.identifier;"
                            withParameterDictionary:@{
                                    @"endDate" : @(dateSection.date),
                            }];

    NSMutableArray *categories = [NSMutableArray new];
    while ([resultSet next]) {
        HTLCategoryDto *category = [self categoryWithResultSet:resultSet];
        if (category) {
            [categories addObject:category];
        }
    }
    [resultSet close];

    return [categories copy];
}

- (HTLActionDto *)storeAction:(HTLActionDto *)action database:(FMDatabase *)database {
    BOOL success = [database executeUpdate:@"INSERT OR REPLACE INTO action VALUES (:identifier, :title);"
                   withParameterDictionary:@{
                           @"identifier" : action.identifier,
                           @"title" : action.title
                   }];

    if (success) {
        DDLogVerbose(@"Action %@ successfully inserted.", action);
        return action;
    } else {
        DDLogError(@"Unable to insert action %@.", action);
        return nil;
    }
}

- (HTLCategoryDto *)storeCategory:(HTLCategoryDto *)category database:(FMDatabase *)database {
    BOOL success = [database executeUpdate:@"INSERT OR REPLACE INTO category VALUES (:identifier, :title, :color)"
                   withParameterDictionary:@{
                           @"identifier" : category.identifier,
                           @"title" : category.title,
                           @"color" : [UIColor hexStringFromRGBColor:category.color]
                   }];

    if (success) {
        DDLogVerbose(@"Category %@ successfully inserted.", category);
        return category;
    } else {
        DDLogError(@"Unable to insert category %@.", category);
        return nil;
    }
}

- (HTLReportDto *)storeReport:(HTLReportDto *)report database:(FMDatabase *)database {
    NSTimeInterval startDateInterval;
    NSTimeInterval startTimeInterval;
    NSString *startZoneComponentString;
    [report.startDate disassembleToDateInterval:&startDateInterval timeInterval:&startTimeInterval zone:&startZoneComponentString];

    NSTimeInterval endDateInterval;
    NSTimeInterval endTimeInterval;
    NSString *endZoneComponentString;
    [report.endDate disassembleToDateInterval:&endDateInterval timeInterval:&endTimeInterval zone:&endZoneComponentString];

    BOOL success = [database executeUpdate:@"INSERT OR REPLACE INTO report VALUES (:identifier, :actionIdentifier, :categoryIdentifier, :startDate, :startTime, :startZone, :endDate, :endTime, :endZone)"
                   withParameterDictionary:@{
                           @"identifier" : report.identifier,
                           @"actionIdentifier" : report.actionIdentifier,
                           @"categoryIdentifier" : report.categoryIdentifier,
                           @"startDate" : @(startDateInterval),
                           @"startTime" : @(startTimeInterval),
                           @"startZone" : startZoneComponentString,
                           @"endDate" : @(endDateInterval),
                           @"endTime" : @(endTimeInterval),
                           @"endZone" : endZoneComponentString,
                   }];

    if (success) {
        DDLogVerbose(@"Report %@ successfully inserted.", report);
        return report;
    } else {
        DDLogError(@"Unable to insert report %@.", report);
        return nil;
    }
}

- (NSArray *)reportSectionsInDatabase:(FMDatabase *)database {

    FMResultSet *resultSet = [database executeQuery:
            @"SELECT "
                    "endDate, "
                    "endTime, "
                    "endZone "
                    "FROM report "
                    "GROUP BY endDate "
                    "ORDER BY endDate ASC;"];

    NSMutableArray *sections = [NSMutableArray new];
    while ([resultSet next]) {
        HTLDateSectionDto *dateSection = [self dateSectionWithResultSet:resultSet];
        if (dateSection) {
            [sections addObject:dateSection];
        }
    }
    [resultSet close];

    return [NSArray arrayWithArray:sections];
}

- (NSArray *)reportsExtendedInDatabase:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:
            @"SELECT "
                    "report.identifier AS identifier, "
                    "actionIdentifier, "
                    "action.title AS actionTitle, "
                    "categoryIdentifier, "
                    "category.title AS categoryTitle, "
                    "category.color AS categoryColor, "
                    "report.startDate AS reportStartDate, "
                    "report.startTime AS reportStartTime, "
                    "report.startZone AS reportStartZone, "
                    "report.endDate AS reportEndDate, "
                    "report.endTime AS reportEndTime, "
                    "report.endZone AS reportEndZone "
                    "FROM report "
                    "INNER JOIN category ON report.categoryIdentifier = category.identifier "
                    "INNER JOIN action ON report.actionIdentifier = action.identifier "
                    "ORDER BY report.startDate ASC, report.startTime ASC;"];

    NSMutableArray *reportsExtended = [NSMutableArray new];
    while ([resultSet next]) {
        HTLReportExtendedDto *reportExtended = [self reportExtendedWithResultSet:resultSet];
        if (reportExtended) {
            [reportsExtended addObject:reportExtended];
        }
    }
    [resultSet close];

    return [reportsExtended copy];
}

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection database:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:@"SELECT "
                    "report.identifier AS identifier, "
                    "actionIdentifier, "
                    "action.title AS actionTitle, "
                    "categoryIdentifier, "
                    "category.title AS categoryTitle, "
                    "category.color AS categoryColor, "
                    "report.startDate AS reportStartDate, "
                    "report.startTime AS reportStartTime, "
                    "report.startZone AS reportStartZone, "
                    "report.endDate AS reportEndDate, "
                    "report.endTime AS reportEndTime, "
                    "report.endZone AS reportEndZone "
                    "FROM report "
                    "INNER JOIN category ON report.categoryIdentifier = category.identifier "
                    "INNER JOIN action ON report.actionIdentifier = action.identifier "
                    "WHERE report.endDate = :dateSectionDate "
                    "ORDER BY report.endDate ASC, report.endTime ASC "
                    ";"
                            withParameterDictionary:@{@"dateSectionDate" : @(dateSection.date)}];

    NSMutableArray *reportsExtended = [NSMutableArray new];
    while ([resultSet next]) {
        HTLReportExtendedDto *reportExtended = [self reportExtendedWithResultSet:resultSet];
        if (reportExtended) {
            [reportsExtended addObject:reportExtended];
        }
    }
    [resultSet close];

    return [reportsExtended copy];
}

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection category:(HTLCategoryDto *)category database:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:@"SELECT "
                    "report.identifier AS identifier, "
                    "actionIdentifier, "
                    "action.title AS actionTitle, "
                    "categoryIdentifier, "
                    "category.title AS categoryTitle, "
                    "category.color AS categoryColor, "
                    "report.startDate AS reportStartDate, "
                    "report.startTime AS reportStartTime, "
                    "report.startZone AS reportStartZone, "
                    "report.endDate AS reportEndDate, "
                    "report.endTime AS reportEndTime, "
                    "report.endZone AS reportEndZone "
                    "FROM report "
                    "INNER JOIN category ON report.categoryIdentifier = category.identifier "
                    "INNER JOIN action ON report.actionIdentifier = action.identifier "
                    "WHERE report.endDate = :endDate "
                    "AND report.categoryIdentifier = :categoryIdentifier "
                    "ORDER BY report.endDate ASC, report.endTime ASC "
                    ";"
                            withParameterDictionary:@{
                                    @"endDate" : @(dateSection.date),
                                    @"categoryIdentifier" : category.identifier
                            }];

    NSMutableArray *reportsExtended = [NSMutableArray new];
    while ([resultSet next]) {
        HTLReportExtendedDto *reportExtended = [self reportExtendedWithResultSet:resultSet];
        if (reportExtended) {
            [reportsExtended addObject:reportExtended];
        }
    }
    [resultSet close];

    return [reportsExtended copy];
}

- (NSDate *)lastReportEndDateInDatabase:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:
            @"SELECT "
                    "endDate, "
                    "endTime, "
                    "endZone "
                    "FROM report "
                    "ORDER BY endDate DESC, endTime DESC "
                    "LIMIT 1;"];

    NSDate *lastReportEndDate;
    while ([resultSet next]) {
        lastReportEndDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"endDate"]
                                            timeInterval:[resultSet doubleForColumn:@"endTime"]
                                                    zone:[resultSet stringForColumn:@"endZone"]];
    }
    [resultSet close];

    return lastReportEndDate;
}

- (HTLReportExtendedDto *)lastReportExtendedInDatabase:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:
            @"SELECT "
                    "report.identifier AS identifier, "
                    "actionIdentifier, "
                    "action.title AS actionTitle, "
                    "categoryIdentifier, "
                    "category.title AS categoryTitle, "
                    "category.color AS categoryColor, "
                    "report.startDate AS reportStartDate, "
                    "report.startTime AS reportStartTime, "
                    "report.startZone AS reportStartZone, "
                    "report.endDate AS reportEndDate, "
                    "report.endTime AS reportEndTime, "
                    "report.endZone AS reportEndZone "
                    "FROM report "
                    "INNER JOIN category ON report.categoryIdentifier = category.identifier "
                    "INNER JOIN action ON report.actionIdentifier = action.identifier "
                    "ORDER BY report.startDate DESC, report.startTime DESC LIMIT 1;"];

    HTLReportExtendedDto *lastReportExtended;
    if ([resultSet next]) {
        lastReportExtended = [self reportExtendedWithResultSet:resultSet];
    }
    [resultSet close];

    return lastReportExtended;
}

- (NSArray *)completionsWithPattern:(NSString *)pattern database:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:@"SELECT "
                    "actionIdentifier, "
                    "action.title AS actionTitle, "
                    "categoryIdentifier, "
                    "category.title AS categoryTitle, "
                    "category.color AS categoryColor, "
                    "COUNT(action.title) as weight "
                    "FROM report "
                    "INNER JOIN category ON report.categoryIdentifier = category.identifier "
                    "INNER JOIN action ON report.actionIdentifier = action.identifier "
                    "WHERE action.title LIKE :pattern "
                    "GROUP BY action.title "
                    "ORDER BY weight DESC;"
                            withParameterDictionary:@{@"pattern" : [NSString stringWithFormat:@"%%%@%%", pattern]}];

    NSMutableArray *completions = [NSMutableArray new];
    while ([resultSet next]) {
        HTLCompletionDto *completion = [self completionWithResultSet:resultSet];
        if (completion) {
            [completions addObject:completion];
        }
    }
    [resultSet close];

    return [NSArray arrayWithArray:completions];
}

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        cache_ = [NSCache new];
        categoriesBySectionCache_ = [NSCache new];
        reportsExtendedBySectionCache_ = [NSCache new];
        reportsExtendedByCategoryAndSectionCache_ = [NSCache new];
        completionByPatternCache_ = [NSCache new];
        folderMonitor_ = [DTFolderMonitor folderMonitorForURL:self.storageFileFolderURL block:^{
            [self clearCaches];
            [[NSNotificationCenter defaultCenter] postNotificationName:kHTLStorageProviderChangedNotification object:nil];
        }];
        [folderMonitor_ startMonitoring];
    }
    return self;
}

#pragma mark - HTLStorageProvider

- (BOOL)clear {
    [self clearCaches];
    NSError *error;
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:self.storageFilePath error:&error];
    if (error) {
        DDLogError(@"%@", error.localizedDescription);
    }
    return result;
}

- (NSArray *)categories {
    NSArray *cachedCategories = [self.cache objectForKey:kCategoriesCacheKey];
    if (cachedCategories) {
        return cachedCategories;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *categories = [self categoriesInDatabase:database];

    [database close];

    [self.cache setObject:categories forKey:kCategoriesCacheKey];

    return categories;
}

- (NSArray *)categoriesWithDateSection:(HTLDateSectionDto *)dateSection {
    if (!dateSection) {
        // Return categories for all sections if dateSection not specified.
        return [self categories];
    }

    NSArray *cachedCategories = [self.categoriesBySectionCache objectForKey:@(dateSection.hash)];
    if (cachedCategories) {
        return cachedCategories;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *categories = [self categoriesWithDateSection:dateSection database:database];

    [database close];

    [self.categoriesBySectionCache setObject:categories forKey:@(dateSection.hash)];

    return categories;
}

- (BOOL)storeCategory:(HTLCategoryDto *)category {
    if (!category) {
        return NO;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return NO;
    }

    [self clearCaches];

    HTLCategoryDto *added = [self storeCategory:category database:database];
    if (!added) {
        [database close];
        return NO;
    }

    [database close];
    return YES;
}

- (NSArray *)reportSections {
    NSArray *cached = [self.cache objectForKey:kReportSectionsCacheKey];
    if (cached) {
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *reportSections = [self reportSectionsInDatabase:database];

    [database close];

    [self.cache setObject:reportSections forKey:kReportSectionsCacheKey];

    return reportSections;
}

- (NSArray *)reportsExtended {
    NSArray *cached = [self.cache objectForKey:kReportsExtendedCacheKey];
    if (cached) {
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *reportsExtended = [self reportsExtendedInDatabase:database];

    [database close];

    [self.cache setObject:reportsExtended forKey:kReportsExtendedCacheKey];

    return reportsExtended;
}

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection {
    if (!dateSection) {
        return [self reportsExtended];
    }

    NSArray *cached = [self.reportsExtendedBySectionCache objectForKey:@(dateSection.hash)];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Reports Extended for Date Section %@", dateSection);
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *reportsExtended = [self reportsExtendedWithDateSection:dateSection database:database];

    [database close];

    NSArray *result = [NSArray arrayWithArray:reportsExtended];
    [self.reportsExtendedBySectionCache setObject:result forKey:@(dateSection.hash)];

    return result;
}

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection category:(HTLCategoryDto *)category {
    if (!category) {
        return [self reportsExtendedWithDateSection:dateSection];
    }

    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@", @(dateSection.hash), @(category.hash)];
    NSArray *cached = [self.reportsExtendedByCategoryAndSectionCache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Last Report End Date");
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *reportsExtended = [self reportsExtendedWithDateSection:dateSection category:category database:database];

    [database close];

    NSArray *result = [NSArray arrayWithArray:reportsExtended];

    [self.reportsExtendedByCategoryAndSectionCache setObject:result forKey:cacheKey];

    return result;
}

- (BOOL)storeReportExtended:(HTLReportExtendedDto *)reportExtended {
    if (!reportExtended) {
        return NO;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return NO;
    }

    [self clearCaches];

    HTLActionDto *action = [self storeAction:reportExtended.action database:database];
    if (!action) {
        [database close];
        return NO;
    }

    HTLCategoryDto *category = [self storeCategory:reportExtended.category database:database];
    if (!category) {
        [database close];
        return NO;
    }

    HTLReportDto *report = [HTLReportDto reportWithIdentifier:reportExtended.report.identifier
                                             actionIdentifier:action.identifier
                                           categoryIdentifier:category.identifier
                                                    startDate:reportExtended.report.startDate
                                                      endDate:reportExtended.report.endDate];
    HTLReportDto *storedReport = [self storeReport:report database:database];
    if (!storedReport) {
        [database close];
        return NO;
    }

    [database close];

    return YES;
}

- (NSDate *)lastReportEndDate {
    NSDate *cached = [self.cache objectForKey:kLastReportEndDateCacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Last Report End Date");
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return nil;
    }

    NSDate *lastReportEndDate = [self lastReportEndDateInDatabase:database];

    [database close];

    if (lastReportEndDate) {
        [self.cache setObject:lastReportEndDate forKey:kLastReportEndDateCacheKey];
    }

    return lastReportEndDate;
}

- (HTLReportExtendedDto *)lastReportExtended {
    HTLReportExtendedDto *cached = [self.cache objectForKey:kLastReportExtendedCacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Last Report Extended");
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return nil;
    }

    HTLReportExtendedDto *lastReportExtended = [self lastReportExtendedInDatabase:database];

    [database close];

    if (lastReportExtended) {
        [self.cache setObject:lastReportExtended forKey:kLastReportExtendedCacheKey];
    }

    return lastReportExtended;
}

- (NSArray *)completionsWithText:(NSString *)text {
    NSString *pattern = text ? text : @"";

    NSArray *cached = [self.completionByPatternCache objectForKey:pattern];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Completions for pattern %@", pattern);
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *completions = [self completionsWithPattern:pattern database:database];

    [database close];

    [self.completionByPatternCache setObject:completions forKey:pattern];

    return completions;
}

@end

