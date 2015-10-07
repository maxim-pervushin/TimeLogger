//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "DTFolderMonitor.h"
#import "FMDB.h"
#import "HTLCategory.h"
#import "HTLDateSection.h"
#import "HTLReport.h"
#import "HTLSqliteStorageProvider+Deserialization.h"
#import "NSDate+HTLComponents.h"


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
                @"CREATE TABLE category("
                        "identifier TEXT PRIMARY KEY, "
                        "title TEXT, "
                        "subTitle TEXT, "
                        "color TEXT"
                        ");"];

        DDLogVerbose(@"category table created: %@", result ? @"YES" : @"NO");

        result = [database executeUpdate:
                @"CREATE TABLE report("
                        "categoryIdentifier TEXT, "
                        "categoryTitle TEXT, "
                        "categorySubTitle TEXT, "
                        "categoryColor TEXT, "
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
                                                               "category.subTitle AS categorySubTitle, "
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
        HTLCategory *category = [self unpackCategory:resultSet];
        if (category) {
            [categories addObject:category];
        }
    }
    [resultSet close];

    return [categories copy];
}

- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSection *)dateSection database:(FMDatabase *)database {
    NSMutableString *whereString = [NSMutableString new];
    if (dateSection) {
        [whereString appendString:
                @"INNER JOIN report ON report.categoryIdentifier = category.identifier "
                        "WHERE report.endDate = :endDate "
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
        parameters[@"endDate"] = dateSection.dateString;
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
                            "subTitle AS categorySubTitle, "
                            "color AS categoryColor "
                            "FROM category "
                            "WHERE title = :title "
                            "LIMIT 1;"
                            withParameterDictionary:@{
                                    @"title" : title ? title : @""
                            }];

    HTLCategory *result;
    if ([resultSet next]) {
        result = [self unpackCategory:resultSet];
    }
    return result;
}

- (BOOL)deleteCategory:(HTLCategory *)category database:(FMDatabase *)database {
    BOOL success = [database executeUpdate:@"DELETE FROM category WHERE identifier = :identifier"
                   withParameterDictionary:@{
                           @"identifier" : category.identifier
                   }];

    if (success) {
        DDLogVerbose(@"Category %@ successfully inserted.", category);
    } else {
        DDLogError(@"Unable to insert category %@.", category);
    }
    return success;
}

- (BOOL)saveCategory:(HTLCategory *)category database:(FMDatabase *)database {
    BOOL success = [database executeUpdate:@"INSERT OR REPLACE INTO category VALUES (:identifier, :title, :subTitle, :color)"
                   withParameterDictionary:@{
                           @"identifier" : category.identifier,
                           @"title" : category.title,
                           @"subTitle" : category.subTitle ? category.subTitle : @"",
                           @"color" : [UIColor hexStringFromRGBColor:category.color]
                   }];

    if (success) {
        DDLogVerbose(@"Category %@ successfully inserted.", category);
    } else {
        DDLogError(@"Unable to insert category %@.", category);
    }
    return success;
}

- (BOOL)saveReport:(HTLReport *)report database:(FMDatabase *)database {
    NSString *startDateString;
    NSString *startTimeString;
    NSString *startTimeZoneString;
    [report.startDate getDateString:&startDateString timeString:&startTimeString timeZoneString:&startTimeZoneString];

    NSString *endDateString;
    NSString *endTimeString;
    NSString *endTimeZoneString;
    [report.endDate getDateString:&endDateString timeString:&endTimeString timeZoneString:&endTimeZoneString];

    BOOL success = [database executeUpdate:@"INSERT OR REPLACE INTO report VALUES (:categoryIdentifier, :categoryTitle, :categorySubTitle, :categoryColor, :startDate, :startTime, :startZone, :endDate, :endTime, :endZone)"
                   withParameterDictionary:@{
                           @"categoryIdentifier" : report.category.identifier,
                           @"categoryTitle" : report.category.title,
                           @"categorySubTitle" : report.category.subTitle,
                           @"categoryColor" : [UIColor hexStringFromRGBColor:report.category.color],
                           @"startDate" : startDateString,
                           @"startTime" : startTimeString,
                           @"startZone" : startTimeZoneString,
                           @"endDate" : endDateString,
                           @"endTime" : endTimeString,
                           @"endZone" : endTimeZoneString,
                   }];

    if (success) {
        DDLogVerbose(@"Report %@ successfully inserted.", report);
    } else {
        DDLogError(@"Unable to insert report %@.", report);
    }
    return success;
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

- (NSArray *)dateSectionsInDatabase:(FMDatabase *)database {

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
        HTLDateSection *dateSection = [self unpackDateSection:resultSet];
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
        [whereString appendString:@"WHERE report.endDate = :endDate "
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
        parameters[@"endDate"] = dateSection.dateString;
    }


    FMResultSet *resultSet = [database executeQuery:queryString withParameterDictionary:parameters];

    NSUInteger result = 0;
    if ([resultSet next]) {
        result = (NSUInteger) [resultSet intForColumn:@"count"];
    }
    [resultSet close];

    return result;
}

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category database:(FMDatabase *)database {

    NSMutableString *whereString = [NSMutableString new];
    if (dateSection) {
        [whereString appendString:@"WHERE report.endDate = :endDate "];
    }
    if (category) {
        // TODO: Compare by category title and subtitle
        [whereString appendFormat:@"%@ report.categoryIdentifier = :reportCategoryIdentifier", whereString.length > 0 ? @"AND" : @"WHERE"];
    }

    NSString *queryString =
            [NSString stringWithFormat:@"SELECT "
                                               "report.categoryIdentifier AS reportCategoryIdentifier, "
                                               "report.categoryTitle AS reportCategoryTitle, "
                                               "report.categorySubTitle AS reportCategorySubTitle, "
                                               "report.categoryColor AS reportCategoryColor, "
                                               "report.startDate AS reportStartDate, "
                                               "report.startTime AS reportStartTime, "
                                               "report.startZone AS reportStartZone, "
                                               "report.endDate AS reportEndDate, "
                                               "report.endTime AS reportEndTime, "
                                               "report.endZone AS reportEndZone "
                                               "FROM report "
                                               "%@ "
                                               "ORDER BY report.endDate ASC, report.endTime ASC "
                                               ";", whereString];

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (dateSection) {
        parameters[@"endDate"] = dateSection.dateString;
    }
    if (category) {
        parameters[@"reportCategoryIdentifier"] = category.identifier;
    }

    FMResultSet *resultSet = [database executeQuery:queryString withParameterDictionary:parameters];

    NSMutableArray *reports = [NSMutableArray new];
    while ([resultSet next]) {
        HTLReport *report = [self unpackReport:resultSet];
        if (report) {
            [reports addObject:report];
        }
    }
    [resultSet close];

    return [reports copy];
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

- (HTLReport *)lastReportInDatabase:(FMDatabase *)database {
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

    HTLReport *lastReport;
    if ([resultSet next]) {
        lastReport = [self unpackReport:resultSet];
    }
    [resultSet close];

    return lastReport;
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

- (NSArray *)categoriesWithDateSection:(HTLDateSection *)dateSection {
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

- (BOOL)saveCategory:(HTLCategory *)category {
    if (!category) {
        return NO;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return NO;
    }

    [self clearCaches];

    if (![self saveCategory:category database:database]) {
        [database close];
        return NO;
    }

    [database close];
    return YES;
}

- (BOOL)deleteCategory:(HTLCategory *)category {
    if (!category) {
        return NO;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return NO;
    }

    [self clearCaches];

    BOOL deleted = [self deleteCategory:category database:database];
    [database close];
    return deleted;
}

- (NSUInteger)numberOfDateSections {
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

- (NSArray *)dateSections {
    NSString *cacheKey = NSStringFromSelector(_cmd);
    NSArray *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *reportSections = [self dateSectionsInDatabase:database];

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

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection category:(HTLCategory *)category {
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@_%@",
                                                    NSStringFromSelector(_cmd),
                                                    dateSection ? @(dateSection.hash) : @"",
                                                    category ? @(category.hash) : @""];

    NSArray *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Reports Extended");
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *reportsExtended = [self reportsWithDateSection:dateSection category:category database:database];

    [database close];

    NSArray *result = [NSArray arrayWithArray:reportsExtended];

    [self.cache setObject:result forKey:cacheKey];

    return result;
}

- (BOOL)saveReport:(HTLReport *)report {
    if (!report) {
        return NO;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return NO;
    }

    [self clearCaches];

    HTLCategory *category = [self categoryWithTitle:report.category.title database:database];
    if (!category && ![self saveCategory:report.category database:database]) {
        [database close];
        return NO;
    }

    if (![self saveReport:report database:database]) {
        [database close];
        return NO;
    }

    [database close];

    return YES;
}

- (NSDate *)lastReportEndDate {
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

- (HTLReport *)lastReport {
    NSString *cacheKey = NSStringFromSelector(_cmd);
    HTLReport *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Last Report");
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return nil;
    }

    HTLReport *lastReport = [self lastReportInDatabase:database];

    [database close];

    if (lastReport) {
        [self.cache setObject:lastReport forKey:cacheKey];
    }

    return lastReport;
}

@end

