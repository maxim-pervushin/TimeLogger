//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "DTFolderMonitor.h"
#import "FMDB.h"
#import "HTLActivity.h"
#import "HTLDateSection.h"
#import "HTLReport.h"
#import "HTLSqliteStorageProvider+Deserialization.h"
#import "NSDate+HTLComponents.h"
#import "HTLStatisticsItem.h"
#import "HTLReport+Helpers.h"


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
                        "title TEXT, "
                        "subTitle TEXT, "
                        "color TEXT"
                        ");"];

        DDLogVerbose(@"category table created: %@", result ? @"YES" : @"NO");

        result = [database executeUpdate:
                @"CREATE TABLE report("
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

- (NSArray *)customCategoriesInDatabase:(FMDatabase *)database {

    NSString *query = @"SELECT "
            "title AS categoryTitle, "
            "subTitle AS categorySubTitle, "
            "color AS categoryColor "
            "FROM category "
            "GROUP BY title "
            "ORDER BY title;";

    FMResultSet *resultSet = [database executeQuery:query withParameterDictionary:@{}];

    NSMutableArray *categories = [NSMutableArray new];
    while ([resultSet next]) {
        HTLActivity *category = [self unpackActivity:resultSet];
        if (category) {
            [categories addObject:category];
        }
    }
    [resultSet close];

    return [categories copy];
}

- (BOOL)deleteCategory:(HTLActivity *)category database:(FMDatabase *)database {

    NSString *query = @"DELETE "
            "FROM category "
            "WHERE title = :title "
            "AND subTitle = :subTitle "
            "AND color = :color;";

    NSDictionary *parameters = @{
            @"title" : category.title,
            @"subTitle" : category.subTitle,
            @"color" : [UIColor hexStringFromRGBColor:category.color]
    };

    BOOL success = [database executeUpdate:query withParameterDictionary:parameters];

    if (success) {
        DDLogVerbose(@"Category %@ successfully inserted.", category);
    } else {
        DDLogError(@"Unable to insert category %@.", category);
    }

    return success;
}

- (BOOL)saveCategory:(HTLActivity *)category database:(FMDatabase *)database {

    NSString *query = @"INSERT OR REPLACE INTO category VALUES (:title, :subTitle, :color)";

    NSDictionary *parameters = @{
            @"title" : category.title ? category.title : @"",
            @"subTitle" : category.subTitle ? category.subTitle : @"",
            @"color" : category.color ? [UIColor hexStringFromRGBColor:category.color] : @""
    };

    BOOL success = [database executeUpdate:query withParameterDictionary:parameters];

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

    NSString *query = @"INSERT OR REPLACE "
            "INTO report VALUES ("
            ":categoryTitle, "
            ":categorySubTitle, "
            ":categoryColor, "
            ":startDate, "
            ":startTime, "
            ":startZone, "
            ":endDate, "
            ":endTime, "
            ":endZone)";

    NSDictionary *parameters = @{
            @"categoryTitle" : report.category.title,
            @"categorySubTitle" : report.category.subTitle,
            @"categoryColor" : [UIColor hexStringFromRGBColor:report.category.color],
            @"startDate" : startDateString,
            @"startTime" : startTimeString,
            @"startZone" : startTimeZoneString,
            @"endDate" : endDateString,
            @"endTime" : endTimeString,
            @"endZone" : endTimeZoneString,
    };

    BOOL success = [database executeUpdate:query withParameterDictionary:parameters];

    if (success) {
        DDLogVerbose(@"Report %@ successfully inserted.", report);
    } else {
        DDLogError(@"Unable to insert report %@.", report);
    }

    return success;
}

- (NSUInteger)numberOfDateSectionsInDatabase:(FMDatabase *)database {

    FMResultSet *resultSet = [database executeQuery:@"SELECT COUNT(DISTINCT endDate) as count FROM report"];

    NSUInteger result = 0;
    if ([resultSet next]) {
        result = (NSUInteger) [resultSet intForColumn:@"count"];
    }
    [resultSet close];

    return result;
}

- (NSArray *)dateSectionsInDatabase:(FMDatabase *)database {

    NSString *query = @"SELECT endDate, endTime, endZone FROM report GROUP BY endDate ORDER BY endDate ASC;";

    FMResultSet *resultSet = [database executeQuery:query];

    NSMutableArray *sections = [NSMutableArray new];
    while ([resultSet next]) {
        HTLDateSection *dateSection = [self unpackDateSection:resultSet];
        if (dateSection) {
            [sections addObject:dateSection];
        }
    }
    [resultSet close];

    return [sections copy];
}

- (NSUInteger)numberOfReportsWithDateSection:(HTLDateSection *)dateSection database:(FMDatabase *)database {

    NSMutableString *whereString = [NSMutableString new];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (dateSection) {
        [whereString appendString:@"WHERE report.endDate = :endDate "];
        parameters[@"endDate"] = dateSection.dateString;
    }

    NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM report %@;", whereString];

    FMResultSet *resultSet = [database executeQuery:query withParameterDictionary:parameters];

    NSUInteger result = 0;
    if ([resultSet next]) {
        result = (NSUInteger) [resultSet intForColumn:@"count"];
    }
    [resultSet close];

    return result;
}

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection category:(HTLActivity *)category database:(FMDatabase *)database {

    NSMutableString *whereString = [NSMutableString new];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (dateSection) {
        [whereString appendString:@"WHERE endDate = :endDate "];
        parameters[@"endDate"] = dateSection.dateString;
    }
    if (category) {
        [whereString appendFormat:@"%@ categoryTitle = :categoryTitle AND categorySubTitle = :categorySubTitle AND categoryColor = :categoryColor", whereString.length > 0 ? @"AND" : @"WHERE"];
        parameters[@"categoryTitle"] = category.title;
        parameters[@"categorySubTitle"] = category.subTitle;
        parameters[@"categoryColor"] = category.color;
    }

    NSString *query =
            [NSString stringWithFormat:@"SELECT "
                                               "categoryTitle AS categoryTitle, "
                                               "categorySubTitle AS categorySubTitle, "
                                               "categoryColor AS categoryColor, "
                                               "startDate AS startDate, "
                                               "startTime AS startTime, "
                                               "startZone AS startZone, "
                                               "endDate AS endDate, "
                                               "endTime AS endTime, "
                                               "endZone AS endZone "
                                               "FROM report "
                                               "%@ "
                                               "ORDER BY endDate ASC, endTime ASC "
                                               ";", whereString];

    FMResultSet *resultSet = [database executeQuery:query withParameterDictionary:parameters];

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
                    "endDate AS endDate, "
                    "endTime AS endTime, "
                    "endZone AS endZone "
                    "FROM report "
                    "ORDER BY endDate DESC, endTime DESC "
                    "LIMIT 1;"];

    NSDate *lastReportEndDate;
    while ([resultSet next]) {
        lastReportEndDate = [NSDate dateWithDateString:[resultSet stringForColumn:@"endDate"]
                                            timeString:[resultSet stringForColumn:@"endTime"]
                                        timeZoneString:[resultSet stringForColumn:@"endZone"]];
    }
    [resultSet close];

    return lastReportEndDate;
}

- (HTLReport *)lastReportInDatabase:(FMDatabase *)database {
    FMResultSet *resultSet = [database executeQuery:
            @"SELECT "
                    "categoryTitle AS categoryTitle, "
                    "categorySubTitle AS categorySubTitle, "
                    "categoryColor AS categoryColor, "
                    "startDate AS startDate, "
                    "startTime AS startTime, "
                    "startZone AS startZone, "
                    "endDate AS endDate, "
                    "endTime AS endTime, "
                    "endZone AS endZone "
                    "FROM report "
                    "ORDER BY endDate DESC, endTime DESC LIMIT 1;"];

    HTLReport *lastReport;
    if ([resultSet next]) {
        lastReport = [self unpackReport:resultSet];
    }
    [resultSet close];

    return lastReport;
}

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection database:(FMDatabase *)database {

    NSMutableDictionary *endDateParameters = [NSMutableDictionary new];
    if (dateSection) {
        endDateParameters[@"endDate"] = dateSection.dateString;
    }

    NSMutableArray *categories = [[self customCategories] mutableCopy];
    [categories addObjectsFromArray:[self mandatoryCategories]];

    NSMutableArray *result = [NSMutableArray new];
    for (HTLActivity *category in categories) {

        NSMutableDictionary *parameters = [@{
                @"categoryTitle" : category.title,
                @"categorySubTitle" : category.subTitle,
                @"categoryColor" : [UIColor hexStringFromRGBColor:category.color]
        } mutableCopy];
        [parameters addEntriesFromDictionary:endDateParameters];

        NSMutableString *filter = [NSMutableString new];
        for (NSString *parameter in parameters.allKeys) {
            if (filter.length == 0) {
                [filter appendFormat:@"WHERE %@ = :%@ ", parameter, parameter];
            } else {
                [filter appendFormat:@"AND %@ = :%@ ", parameter, parameter];
            }
        }

        NSString *query = [NSString stringWithFormat:@"SELECT "
                                                             "categoryTitle AS categoryTitle, "
                                                             "categorySubTitle AS categorySubTitle, "
                                                             "categoryColor AS categoryColor, "
                                                             "startDate AS startDate, "
                                                             "startTime AS startTime, "
                                                             "startZone AS startZone, "
                                                             "endDate AS endDate, "
                                                             "endTime AS endTime, "
                                                             "endZone AS endZone "
                                                             "FROM report %@;", filter];

        FMResultSet *resultSet = [database executeQuery:query withParameterDictionary:parameters];

        NSTimeInterval totalTime = 0;
        NSUInteger totalReports = 0;
        while ([resultSet next]) {
            HTLReport *report = [self unpackReport:resultSet];
            if (report) {
                totalTime += report.duration;
            }
            totalReports++;
        }
        [resultSet close];

        [result addObject:[HTLStatisticsItem statisticsItemWithCategory:category
                                                              totalTime:totalTime
                                                           totalReports:totalReports]];
    }

    return [result copy];
//    NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM report %@;", endDateFilter];

//    FMResultSet *resultSet = [database executeQuery:query withParameterDictionary:endDateParameters];

//    NSUInteger result = 0;
//    if ([resultSet next]) {
//        result = (NSUInteger) [resultSet intForColumn:@"count"];
//    }
//    [resultSet close];
//
//    return result;
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

- (NSArray *)mandatoryCategories {
    NSString *cacheKey = NSStringFromSelector(_cmd);
    NSArray *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Mandatory Categories");
        return cached;
    }

    NSArray *result = @[
            [HTLActivity categoryWithTitle:@"Sleep" subTitle:@"" color:[UIColor paperColorDeepPurple]],
            [HTLActivity categoryWithTitle:@"Personal" subTitle:@"" color:[UIColor paperColorIndigo]],
            [HTLActivity categoryWithTitle:@"Road" subTitle:@"" color:[UIColor paperColorRed]],
            [HTLActivity categoryWithTitle:@"Work" subTitle:@"" color:[UIColor paperColorLightGreen]],
            [HTLActivity categoryWithTitle:@"Improvement" subTitle:@"" color:[UIColor paperColorDeepOrange]],
            [HTLActivity categoryWithTitle:@"Recreation" subTitle:@"" color:[UIColor paperColorCyan]],
            [HTLActivity categoryWithTitle:@"Time Waste" subTitle:@"" color:[UIColor paperColorBrown]]
    ];

    [self.cache setObject:result forKey:cacheKey];

    return result;
}

- (NSArray *)customCategories {
    NSString *cacheKey = NSStringFromSelector(_cmd);
    NSArray *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Custom Categories");
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *result = [self customCategoriesInDatabase:database];

    [database close];

    [self.cache setObject:result forKey:cacheKey];

    return result;
}

//- (NSUInteger)numberOfCategoriesWithDateSection:(HTLDateSection *)dateSection {
//    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@",
//                                                    NSStringFromSelector(_cmd),
//                                                    dateSection ? @(dateSection.hash) : @""];
//    NSNumber *cached = [self.cache objectForKey:cacheKey];
//    if (cached) {
//        DDLogVerbose(@"Retrieving cached Number of Categories for Date Section %@", dateSection);
//        return cached.unsignedIntegerValue;
//    }
//
//    FMDatabase *database = self.databaseOpen;
//    if (!database) {
//        return 0;
//    }
//
//    NSUInteger result = [self numberOfCategoriesWithDateSection:dateSection database:database];
//
//    [database close];
//
//    [self.cache setObject:@(result) forKey:cacheKey];
//
//    return result;
//}
//
//- (NSArray *)categoriesWithDateSection:(HTLDateSection *)dateSection {
//    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@",
//                                                    NSStringFromSelector(_cmd),
//                                                    dateSection ? @(dateSection.hash) : @""];
//    NSArray *cachedCategories = [self.cache objectForKey:cacheKey];
//    if (cachedCategories) {
//        return cachedCategories;
//    }
//
//    FMDatabase *database = self.databaseOpen;
//    if (!database) {
//        return @[];
//    }
//
//    NSArray *categories = [self categoriesWithDateSection:dateSection database:database];
//
//    [database close];
//
//    [self.cache setObject:categories forKey:cacheKey];
//
//    return categories;
//}

- (BOOL)saveCategory:(HTLActivity *)category {
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

- (BOOL)deleteCategory:(HTLActivity *)category {
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

    NSUInteger result = [self numberOfDateSectionsInDatabase:database];

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

- (NSArray *)reportsWithDateSection:(HTLDateSection *)dateSection category:(HTLActivity *)category {
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

- (NSArray *)statisticsWithDateSection:(HTLDateSection *)dateSection {
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@",
                                                    NSStringFromSelector(_cmd),
                                                    dateSection ? @(dateSection.hash) : @""];
    NSArray *cached = [self.cache objectForKey:cacheKey];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Statistics for Date Section %@", dateSection);
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *result = [self statisticsWithDateSection:dateSection database:database];

    [database close];

    [self.cache setObject:result forKey:cacheKey];

    return result;
}

@end

