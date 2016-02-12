//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "DTFolderMonitor.h"
#import "FMDB.h"
#import "HTLAction.h"
#import "HTLCategory.h"
#import "HTLCompletion.h"
#import "HTLDateSection.h"
#import "HTLReport.h"
#import "HTLReportExtended.h"
#import "HTLSqliteStorageProvider+Deserialization.h"
#import "NSDate+HTLComponents.h"
#import "UIColor+HTLHelpers.h"


@interface HTLSqliteStorageProvider ()

@property(nonatomic, copy) NSURL *storageFolderURL;
@property(nonatomic, copy) NSString *storageFileName;
@property(nonatomic, strong) NSCache *cache;
@property(nonatomic, strong) DTFolderMonitor *folderMonitor;

@end

@implementation HTLSqliteStorageProvider
@synthesize storageFolderURL = storageFolderURL_;
@synthesize storageFileName = storageFileName_;
@synthesize cache = cache_;
@synthesize folderMonitor = folderMonitor_;

#pragma mark - HTLSqliteStorageProvider

+ (instancetype)sqliteStorageProviderWithStorageFolderURL:(NSURL *)storageFolderURL storageFileName:(NSString *)storageFileName {
    return [[self alloc] initWithStorageFolderURL:storageFolderURL storageFileName:storageFileName];
}

- (instancetype)initWithStorageFolderURL:(NSURL *)storageFolderURL storageFileName:(NSString *)storageFileName {
    self = [super init];
    if (self) {
        storageFolderURL_ = [storageFolderURL copy];
        storageFileName_ = [storageFileName copy];
        cache_ = [NSCache new];
        __weak __typeof(self) weakSelf = self;
        folderMonitor_ = [DTFolderMonitor folderMonitorForURL:storageFolderURL_ block:^{
            [weakSelf clearCaches];
            [[NSNotificationCenter defaultCenter] postNotificationName:kHTLStorageProviderChangedNotification object:nil];
        }];
        [self.folderMonitor startMonitoring];
    }
    return self;
}

- (NSString *)storageFilePath {
    return [self.storageFolderURL URLByAppendingPathComponent:self.storageFileName].path;
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
                        "startDate TEXT, "
                        "startTime TEXT, "
                        "startZone TEXT, "
                        "endDate TEXT, "
                        "endTime TEXT, "
                        "endZone TEXT"
                        ");"];

        DDLogVerbose(@"report table created: %@", result ? @"YES" : @"NO");

        [database close];
    }
}

- (void)clearCaches {
    [self.cache removeAllObjects];
}

#pragma mark - DB

- (NSArray *)categoriesWithDateSection:(HTLDateSection *)dateSection database:(FMDatabase *)database {

    NSMutableString *whereString = [NSMutableString new];
    if (dateSection) {
        [whereString appendString:
                @"INNER JOIN report ON report.categoryIdentifier = category.identifier "
                        "WHERE report.endDate = :endDate "];
    }

    NSString *queryString = [NSString stringWithFormat:@"SELECT "
                                                               "category.identifier AS categoryIdentifier, "
                                                               "category.title AS categoryTitle, "
                                                               "category.color AS categoryColor "
                                                               "FROM category "
                                                               "%@ "
                                                               "GROUP BY category.identifier "
                                                               "ORDER BY category.identifier;", whereString];

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (dateSection) {
        parameters[@"endDate"] = dateSection.dateString;
    }

    FMResultSet *resultSet = [database executeQuery:queryString withParameterDictionary:parameters];

    NSMutableArray *categories = [NSMutableArray new];
    while ([resultSet next]) {
        HTLCategory *category = [self categoryWithResultSet:resultSet];
        if (category) {
            [categories addObject:category];
        }
    }
    [resultSet close];

    return [categories copy];
}

- (HTLAction *)actionWithTitle:(NSString *)title database:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:
                    @"SELECT "
                            "identifier AS actionIdentifier, "
                            "title AS actionTitle "
                            "FROM action "
                            "WHERE title = :title "
                            "LIMIT 1;"
                            withParameterDictionary:@{
                                    @"title" : title ? title : @""
                            }];

    HTLAction *result;
    if ([resultSet next]) {
        result = [self actionWithResultSet:resultSet];
    }
    return result;
}

- (HTLAction *)storeAction:(HTLAction *)action database:(FMDatabase *)database {
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

- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSection *)dateSection database:(FMDatabase *)database {
    NSMutableString *whereString = [NSMutableString new];
    if (dateSection) {
        [whereString appendString:
                @"INNER JOIN report ON report.categoryIdentifier = category.identifier "
                        "WHERE report.endDate = :dateSectionDate "
        ];
    }

    NSString *queryString = [NSString stringWithFormat:@"SELECT "
                                                               "COUNT(*) AS count "
                                                               "FROM category "
                                                               "%@"
                                                               ";",
                                                       whereString];

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (dateSection) {
        parameters[@"dateSectionDate"] = dateSection.dateString;
    }

    FMResultSet *resultSet = [database executeQuery:queryString withParameterDictionary:parameters];

    NSUInteger result = 0;
    if ([resultSet next]) {
        result = (NSUInteger) [resultSet intForColumn:@"count"];
    }
    [resultSet close];

    return result;
}

- (HTLCategory *)categoryWithTitle:(NSString *)title database:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:
                    @"SELECT "
                            "identifier AS categoryIdentifier, "
                            "title AS categoryTitle, "
                            "color AS categoryColor "
                            "FROM category "
                            "WHERE title = :title "
                            "LIMIT 1;"
                            withParameterDictionary:@{
                                    @"title" : title ? title : @""
                            }];

    HTLCategory *result;
    if ([resultSet next]) {
        result = [self categoryWithResultSet:resultSet];
    }
    return result;
}

- (HTLCategory *)storeCategory:(HTLCategory *)category database:(FMDatabase *)database {
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

- (HTLReport *)storeReport:(HTLReport *)report database:(FMDatabase *)database {
    NSString *startDateString;
    NSString *startTimeString;
    NSString *startTimeZoneString;
    [report.startDate getDateString:&startDateString timeString:&startTimeString timeZoneString:&startTimeZoneString];

    NSString *endDateString;
    NSString *endTimeString;
    NSString *endTimeZoneString;
    [report.endDate getDateString:&endDateString timeString:&endTimeString timeZoneString:&endTimeZoneString];

    BOOL success = [database executeUpdate:@"INSERT OR REPLACE INTO report VALUES (:identifier, :actionIdentifier, :categoryIdentifier, :startDate, :startTime, :startZone, :endDate, :endTime, :endZone)"
                   withParameterDictionary:@{
                           @"identifier" : report.identifier,
                           @"actionIdentifier" : report.actionIdentifier,
                           @"categoryIdentifier" : report.categoryIdentifier,
                           @"startDate" : startDateString,
                           @"startTime" : startTimeString,
                           @"startZone" : startTimeZoneString,
                           @"endDate" : endDateString,
                           @"endTime" : endTimeString,
                           @"endZone" : endTimeZoneString,
                   }];

    if (success) {
        DDLogVerbose(@"Report %@ successfully inserted.", report);
        return report;
    } else {
        DDLogError(@"Unable to insert report %@.", report);
        return nil;
    }
}

- (NSUInteger)numberOfReportSectionsInDatabase:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:@"SELECT COUNT(DISTINCT endDate) as count FROM report"];

    NSUInteger result = 0;
    if ([resultSet next]) {
        result = (NSUInteger) [resultSet intForColumn:@"count"];
    }
    [resultSet close];

    return result;
}

- (NSArray *)findAllReportSectionsInDatabase:(FMDatabase *)database {

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
        HTLDateSection *dateSection = [self dateSectionWithResultSet:resultSet];
        if (dateSection) {
            [sections addObject:dateSection];
        }
    }
    [resultSet close];

    return [NSArray arrayWithArray:sections];
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection database:(FMDatabase *)database {
    NSMutableString *whereString = [NSMutableString new];
    if (dateSection) {
        [whereString appendString:@"WHERE report.endDate = :dateSectionDate "
        ];
    }

    NSString *queryString = [NSString stringWithFormat:@"SELECT "
                                                               "COUNT(*) AS count "
                                                               "FROM report "
                                                               "%@"
                                                               ";",
                                                       whereString];

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (dateSection) {
        parameters[@"dateSectionDate"] = dateSection.dateString;
    }


    FMResultSet *resultSet = [database executeQuery:queryString withParameterDictionary:parameters];

    NSUInteger result = 0;
    if ([resultSet next]) {
        result = (NSUInteger) [resultSet intForColumn:@"count"];
    }
    [resultSet close];

    return result;
}

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category database:(FMDatabase *)database {

    NSMutableString *whereString = [NSMutableString new];
    if (dateSection) {
        [whereString appendString:@"WHERE report.endDate = :endDate "];
    }
    if (category) {
        [whereString appendFormat:@"%@ report.categoryIdentifier = :categoryIdentifier", whereString.length > 0 ? @"AND" : @"WHERE"];
    }

    NSString *queryString =
            [NSString stringWithFormat:@"SELECT "
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
                                               "%@ "
                                               "ORDER BY report.endDate ASC, report.endTime ASC "
                                               ";", whereString];

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (dateSection) {
        parameters[@"endDate"] = dateSection.dateString;
    }
    if (category) {
        parameters[@"categoryIdentifier"] = category.identifier;
    }

    FMResultSet *resultSet = [database executeQuery:queryString withParameterDictionary:parameters];

    NSMutableArray *reportsExtended = [NSMutableArray new];
    while ([resultSet next]) {
        HTLReportExtended *reportExtended = [self reportExtendedWithResultSet:resultSet];
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
                    "endDate AS reportEndDate, "
                    "endTime AS reportEndTime, "
                    "endZone AS reportEndZone "
                    "FROM report "
                    "ORDER BY endDate DESC, endTime DESC "
                    "LIMIT 1;"];

    NSDate *lastReportEndDate;
    while ([resultSet next]) {
        lastReportEndDate = [NSDate dateWithDateString:[resultSet stringForColumn:@"reportEndDate"]
                                            timeString:[resultSet stringForColumn:@"reportEndTime"]
                                        timeZoneString:[resultSet stringForColumn:@"reportEndZone"]];
    }
    [resultSet close];

    return lastReportEndDate;
}

- (HTLReportExtended *)lastReportExtendedInDatabase:(FMDatabase *)database {
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

    HTLReportExtended *lastReportExtended;
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
        HTLCompletion *completion = [self completionWithResultSet:resultSet];
        if (completion) {
            [completions addObject:completion];
        }
    }
    [resultSet close];

    return [NSArray arrayWithArray:completions];
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

- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSection *)dateSection {
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@",
                                                    NSStringFromSelector(_cmd),
                                                    dateSection ? @(dateSection.hash) : @""];
    NSNumber *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Number of Categories for Date Section %@", dateSection);
        return cached.unsignedIntegerValue;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return 0;
    }

    NSUInteger result = [self numberOfCategoriesWithDateSection:dateSection database:database];

    [database close];

    [self.cache setObject:@(result) forKey:cacheKey];

    return result;
}

- (NSArray *)findCategoriesWithDateSection:(HTLDateSection *)dateSection {
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@",
                                                    NSStringFromSelector(_cmd),
                                                    dateSection ? @(dateSection.hash) : @""];
    NSArray *cachedCategories = [self.cache objectForKey:cacheKey];
    if (cachedCategories) {
        return cachedCategories;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *categories = [self categoriesWithDateSection:dateSection database:database];

    [database close];

    [self.cache setObject:categories forKey:cacheKey];

    return categories;
}

- (BOOL)storeCategory:(HTLCategory *)category {
    if (!category) {
        return NO;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return NO;
    }

    [self clearCaches];

    HTLCategory *added = [self storeCategory:category database:database];
    if (!added) {
        [database close];
        return NO;
    }

    [database close];
    return YES;
}

- (NSUInteger)numberOfReportSections {
    NSString *cacheKey = NSStringFromSelector(_cmd);
    NSNumber *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        return cached.unsignedIntegerValue;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return 0;
    }

    NSUInteger result = [self numberOfReportSectionsInDatabase:database];

    [database close];

    [self.cache setObject:@(result) forKey:cacheKey];

    return result;
}

- (NSArray *)findAllReportSections {
    NSString *cacheKey = NSStringFromSelector(_cmd);
    NSArray *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *reportSections = [self findAllReportSectionsInDatabase:database];

    [database close];

    [self.cache setObject:reportSections forKey:cacheKey];

    return reportSections;
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection {
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@",
                                                    NSStringFromSelector(_cmd),
                                                    dateSection ? @(dateSection.hash) : @""];
    NSNumber *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Number of Reports for Date Section %@", dateSection);
        return cached.unsignedIntegerValue;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return 0;
    }

    NSUInteger result = [self numberOfReportsWithDateSection:dateSection database:database];

    [database close];

    [self.cache setObject:@(result) forKey:cacheKey];

    return result;
}

- (NSArray *)findReportsExtendedWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category {
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@_%@",
                                                    NSStringFromSelector(_cmd),
                                                    dateSection ? @(dateSection.hash) : @"",
                                                    category ? @(category.hash) : @""];

    NSArray *cached = [self.cache objectForKey:cacheKey];
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

    [self.cache setObject:result forKey:cacheKey];

    return result;
}

- (BOOL)storeReportExtended:(HTLReportExtended *)reportExtended {
    if (!reportExtended) {
        return NO;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return NO;
    }

    [self clearCaches];

    HTLAction *action = [self actionWithTitle:reportExtended.action.title database:database];
    if (!action) {
        action = [self storeAction:reportExtended.action database:database];
    }
    if (!action) {
        [database close];
        return NO;
    }

    HTLCategory *category = [self categoryWithTitle:reportExtended.category.title database:database];
    if (!category) {
        category = [self storeCategory:reportExtended.category database:database];
    }
    if (!category) {
        [database close];
        return NO;
    }

    HTLReport *report = [HTLReport reportWithIdentifier:reportExtended.report.identifier
                                       actionIdentifier:action.identifier
                                     categoryIdentifier:category.identifier
                                              startDate:reportExtended.report.startDate
                                                endDate:reportExtended.report.endDate];
    HTLReport *storedReport = [self storeReport:report database:database];
    if (!storedReport) {
        [database close];
        return NO;
    }

    [database close];

    return YES;
}

- (NSDate *)findLastReportEndDate {
    NSString *cacheKey = NSStringFromSelector(_cmd);
    NSDate *cached = [self.cache objectForKey:cacheKey];
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
        [self.cache setObject:lastReportEndDate forKey:cacheKey];
    }

    return lastReportEndDate;
}

- (HTLReportExtended *)findLastReportExtended {
    NSString *cacheKey = NSStringFromSelector(_cmd);
    HTLReportExtended *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Last Report Extended");
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return nil;
    }

    HTLReportExtended *lastReportExtended = [self lastReportExtendedInDatabase:database];

    [database close];

    if (lastReportExtended) {
        [self.cache setObject:lastReportExtended forKey:cacheKey];
    }

    return lastReportExtended;
}

- (NSArray *)findCompletionsWithText:(NSString *)text {
    NSString *pattern = text ? text : @"";
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@", NSStringFromSelector(_cmd), pattern];
    NSArray *cached = [self.cache objectForKey:cacheKey];
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

    [self.cache setObject:completions forKey:cacheKey];

    return completions;
}

@end

