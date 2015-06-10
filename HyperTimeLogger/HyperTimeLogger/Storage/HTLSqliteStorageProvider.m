//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSqliteStorageProvider.h"
#import "HTLReportExtendedDto.h"
#import "FMDB.h"
#import "HTLCategoryDto.h"
#import "HexColor.h"
#import "HTLActionDto.h"
#import "HTLCompletion.h"
#import "NSDate+HTLComponents.h"
#import "HTLDateSectionDto.h"


static NSString *const kApplicationGroup = @"group.timelogger";
static NSString *const kStorageFileName = @"time_logger_storage.db";
static NSString *const kCategoriesCacheKey = @"categories";
static NSString *const kDateSectionsCacheKey = @"dateSections";
static NSString *const kReportsExtendedCacheKey = @"reportsExtended";


@interface HTLSqliteStorageProvider ()

@property(nonatomic, strong) NSCache *categoriesCache;
@property(nonatomic, strong) NSCache *dateSectionsCache;
@property(nonatomic, strong) NSCache *reportsExtendedBySectionCache;
@property(nonatomic, strong) NSCache *reportsExtendedCache;
@property(nonatomic, strong) NSCache *completionsCache;

- (NSURL *)storageFileFolderURL;

- (NSString *)storageFilePath;

- (FMDatabase *)databaseOpen;

- (HTLReportExtendedDto *)reportExtendedWithResultSet:(FMResultSet *)resultSet;

- (HTLCompletion *)completionWithResultSet:(FMResultSet *)resultSet;

@end

@implementation HTLSqliteStorageProvider
@synthesize categoriesCache = categoriesCache_;
@synthesize dateSectionsCache = dateSectionsCache_;
@synthesize reportsExtendedBySectionCache = reportsExtendedBySectionCache_;
@synthesize reportsExtendedCache = reportsExtendedCache_;
@synthesize completionsCache = completionsCache_;

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

- (HTLReportExtendedDto *)reportExtendedWithResultSet:(FMResultSet *)resultSet {
    HTLActionDto *action = [HTLActionDto actionWithIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                                                        title:[resultSet stringForColumn:@"actionTitle"]];
    HTLCategoryDto *category = [HTLCategoryDto categoryWithIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                                                title:[resultSet stringForColumn:@"categoryTitle"]
                                                                color:[UIColor colorWithHexString:[resultSet stringForColumn:@"categoryColor"]]];

    NSDate *startDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"reportStartDate"]
                                        timeInterval:[resultSet doubleForColumn:@"reportStartTime"]
                                                zone:[resultSet stringForColumn:@"reportStartZone"]];

    NSDate *endDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"reportEndDate"]
                                      timeInterval:[resultSet doubleForColumn:@"reportEndTime"]
                                              zone:[resultSet stringForColumn:@"reportEndZone"]];

    return [HTLReportExtendedDto reportWithAction:action
                                         category:category
                                        startDate:startDate
                                          endDate:endDate];
}

- (HTLCompletion *)completionWithResultSet:(FMResultSet *)resultSet {
    HTLActionDto *action = [HTLActionDto actionWithIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                                                        title:[resultSet stringForColumn:@"actionTitle"]];

    HTLCategoryDto *category = [HTLCategoryDto categoryWithIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                                                title:[resultSet stringForColumn:@"categoryTitle"]
                                                                color:[UIColor colorWithHexString:[resultSet stringForColumn:@"categoryColor"]]];

    return [HTLCompletion completionWithAction:action
                                      category:category
                                        weight:(NSUInteger) [resultSet intForColumn:@"weight"]];
}

- (HTLCategoryDto *)categoryWithResultSet:(FMResultSet *)resultSet {
    return [HTLCategoryDto categoryWithIdentifier:[resultSet stringForColumn:@"identifier"]
                                            title:[resultSet stringForColumn:@"title"]
                                            color:[UIColor colorWithHexString:[resultSet stringForColumn:@"color"]]];
}

- (HTLDateSectionDto *)dateSectionWithResultSet:(FMResultSet *)resultSet {
    return [HTLDateSectionDto dateSectionWithDate:[resultSet doubleForColumn:@"endDate"]
                                             time:[resultSet doubleForColumn:@"endTime"]
                                             zone:[resultSet stringForColumn:@"endZone"]];
}

- (void)createTestData {

    FMDatabase *database = [FMDatabase databaseWithPath:[self storageFilePath]];
    if (![database open]) {
        return;
    }

    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM report;"];
    NSUInteger count = 0;
    while ([resultSet next]) {
        count++;
    }
    [resultSet close];

    if (count > 0) {
        [database close];
        return;
    }

    BOOL result = [database executeStatements:@""
            "DROP TABLE IF EXISTS action;"
            "CREATE TABLE action(identifier TEXT PRIMARY KEY, title TEXT);"
            ""
            "DROP TABLE IF EXISTS category;"
            "CREATE TABLE category(identifier TEXT PRIMARY KEY, title TEXT, color TEXT);"
            ""
            "DROP TABLE IF EXISTS report;"
            "CREATE TABLE report(actionIdentifier TEXT, categoryIdentifier TEXT, startDate REAL, startTime REAL, startZone TEXT, endDate REAL, endTime REAL, endZone TEXT);"
            ""
            "INSERT INTO action VALUES('3198A041-3CAD-46E9-B235-CDC183E4B9BA', 'Установил логгер');"
            "INSERT INTO action VALUES('3482C233-D435-4658-A8F9-A217EB5ED4DA', 'Составил антирасписание');"
            "INSERT INTO action VALUES('4D759FA6-8981-4B30-8ED6-3F86A9DD0F83', 'Посамокопался');"
            "INSERT INTO action VALUES('B81673EB-7950-41C4-9B15-D0352678008E', 'Приготовил велосипед');"
            "INSERT INTO action VALUES('204F401D-779E-4EC0-83C4-FCB6E5F9AC91', 'Приготовил ужин');"
            "INSERT INTO action VALUES('5FD84135-E587-4267-B803-40A7032B120E', 'Поужинал');"
            "INSERT INTO action VALUES('E10F8343-4922-4443-8552-9A56B9D47E65', 'Посмотрел фильм');"
            "INSERT INTO action VALUES('A834C302-B257-4457-A150-9926B31F3B55', 'Вымылся');"
            "INSERT INTO action VALUES('14F3528E-4667-4384-9FD2-814B845FCA02', 'Вымыл посуду');"
            "INSERT INTO action VALUES('EF73F78D-1C75-4505-92A1-C82A6DBE4805', 'Почистил зубы');"
            "INSERT INTO action VALUES('DBE7A562-6E79-4C33-84A8-F74F5112CA05', 'Проснулся');"
            "INSERT INTO action VALUES('656D672F-E59E-4764-A02D-F100C64A3427', 'Умылся');"
            "INSERT INTO action VALUES('67C977FD-B4B7-4940-9FC7-204D3BA39030', 'Приготовил завтрак');"
            "INSERT INTO action VALUES('014D1D81-40CC-44C2-96B8-4D6835F5C333', 'Позавтракал');"
            "INSERT INTO action VALUES('3D7187F3-040C-4E91-BAFB-A74949625C79', 'Убрался');"
            "INSERT INTO action VALUES('F5A1FA3E-D000-42DC-B02E-DF3D7EA773DC', 'Собрался');"
            "INSERT INTO action VALUES('BDB8FDB4-B81D-4893-BA42-3BE4E70AEAC2', 'Пришел в офис');"
            "INSERT INTO action VALUES('09385BE4-CDA9-4710-8FAE-7AD5FA015AB1', 'Биды на апворк');"
            "INSERT INTO action VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 'Интернет');"
            "INSERT INTO action VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 'Time Logger');"
            "INSERT INTO action VALUES('F388DE33-3BD7-4360-B17E-A9571E6EAD3C', 'Пришел на обед');"
            "INSERT INTO action VALUES('819443B4-9302-4FEC-B839-71C311031D5D', 'Перекусил');"
            "INSERT INTO action VALUES('C0A7E530-29D0-4802-BA78-C64BA68644A5', 'Пришел домой');"
            "INSERT INTO action VALUES('2C93CA5C-81F2-4ABA-85D2-F4336A140163', 'Собрался на тренировку');"
            "INSERT INTO action VALUES('6225C516-4430-46CF-83B4-0BBF1154F5AE', 'Пришел на тренировку');"
            "INSERT INTO action VALUES('1A2C8C64-6E62-4499-B929-31F8119AECFE', 'Переоделся');"
            "INSERT INTO action VALUES('E9317C01-AB26-4BBD-877B-791AC0FEEC98', 'Потренировался');"
            "INSERT INTO action VALUES('4B4EB9DE-942A-489F-B2FD-FEE38627BBB3', 'Поел');"
            ""
            "INSERT INTO category VALUES(0, 'Sleep', '673AB7');"
            "INSERT INTO category VALUES(1, 'Personal', '3F51B5');"
            "INSERT INTO category VALUES(2, 'Road', 'F44336');"
            "INSERT INTO category VALUES(3, 'Work', '8BC34A');"
            "INSERT INTO category VALUES(4, 'Improvement', 'FF5722');"
            "INSERT INTO category VALUES(5, 'Recreation', '00BCD4');"
            "INSERT INTO category VALUES(6, 'Time Waste', '795548');"
            ""
            "INSERT INTO report VALUES('3198A041-3CAD-46E9-B235-CDC183E4B9BA', 4, 1433624400.0, 946742275.0, 'GMT+3', 1433624400.0, 946742275.0, 'GMT+3');"
            "INSERT INTO report VALUES('3482C233-D435-4658-A8F9-A217EB5ED4DA', 4, 1433624400.0, 946742275.0, 'GMT+3', 1433624400.0, 946742853.0, 'GMT+3');"
            "INSERT INTO report VALUES('4D759FA6-8981-4B30-8ED6-3F86A9DD0F83', 4, 1433624400.0, 946742853.0, 'GMT+3', 1433624400.0, 946749312.0, 'GMT+3');"
            "INSERT INTO report VALUES('B81673EB-7950-41C4-9B15-D0352678008E', 1, 1433624400.0, 946749312.0, 'GMT+3', 1433624400.0, 946750096.0, 'GMT+3');"
            "INSERT INTO report VALUES('204F401D-779E-4EC0-83C4-FCB6E5F9AC91', 1, 1433624400.0, 946750096.0, 'GMT+3', 1433624400.0, 946751807.0, 'GMT+3');"
            "INSERT INTO report VALUES('5FD84135-E587-4267-B803-40A7032B120E', 1, 1433624400.0, 946751807.0, 'GMT+3', 1433624400.0, 946753516.0, 'GMT+3');"
            "INSERT INTO report VALUES('E10F8343-4922-4443-8552-9A56B9D47E65', 5, 1433624400.0, 946753516.0, 'GMT+3', 1433624400.0, 946759258.0, 'GMT+3');"
            "INSERT INTO report VALUES('A834C302-B257-4457-A150-9926B31F3B55', 1, 1433624400.0, 946759258.0, 'GMT+3', 1433710800.0, 946674607.0, 'GMT+3');"
            "INSERT INTO report VALUES('14F3528E-4667-4384-9FD2-814B845FCA02', 1, 1433710800.0, 946674607.0, 'GMT+3', 1433710800.0, 946675381.0, 'GMT+3');"
            "INSERT INTO report VALUES('EF73F78D-1C75-4505-92A1-C82A6DBE4805', 1, 1433710800.0, 946675381.0, 'GMT+3', 1433710800.0, 946675727.0, 'GMT+3');"
            "INSERT INTO report VALUES('DBE7A562-6E79-4C33-84A8-F74F5112CA05', 0, 1433710800.0, 946675727.0, 'GMT+3', 1433710800.0, 946700848.0, 'GMT+3');"
            "INSERT INTO report VALUES('656D672F-E59E-4764-A02D-F100C64A3427', 1, 1433710800.0, 946700848.0, 'GMT+3', 1433710800.0, 946701273.0, 'GMT+3');"
            "INSERT INTO report VALUES('67C977FD-B4B7-4940-9FC7-204D3BA39030', 1, 1433710800.0, 946701273.0, 'GMT+3', 1433710800.0, 946702231.0, 'GMT+3');"
            "INSERT INTO report VALUES('014D1D81-40CC-44C2-96B8-4D6835F5C333', 1, 1433710800.0, 946702231.0, 'GMT+3', 1433710800.0, 946703105.0, 'GMT+3');"
            "INSERT INTO report VALUES('3D7187F3-040C-4E91-BAFB-A74949625C79', 1, 1433710800.0, 946703105.0, 'GMT+3', 1433710800.0, 946703846.0, 'GMT+3');"
            "INSERT INTO report VALUES('EF73F78D-1C75-4505-92A1-C82A6DBE4805', 1, 1433710800.0, 946703846.0, 'GMT+3', 1433710800.0, 946704293.0, 'GMT+3');"
            "INSERT INTO report VALUES('F5A1FA3E-D000-42DC-B02E-DF3D7EA773DC', 1, 1433710800.0, 946704293.0, 'GMT+3', 1433710800.0, 946705207.0, 'GMT+3');"
            "INSERT INTO report VALUES('BDB8FDB4-B81D-4893-BA42-3BE4E70AEAC2', 2, 1433710800.0, 946705207.0, 'GMT+3', 1433710800.0, 946706260.0, 'GMT+3');"
            "INSERT INTO report VALUES('09385BE4-CDA9-4710-8FAE-7AD5FA015AB1', 4, 1433710800.0, 946706260.0, 'GMT+3', 1433710800.0, 946707977.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946707977.0, 'GMT+3', 1433710800.0, 946710060.0, 'GMT+3');"
            "INSERT INTO report VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946710060.0, 'GMT+3', 1433710800.0, 946712441.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946712441.0, 'GMT+3', 1433710800.0, 946714434.0, 'GMT+3');"
            "INSERT INTO report VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946714434.0, 'GMT+3', 1433710800.0, 946715154.0, 'GMT+3');"
            "INSERT INTO report VALUES('F388DE33-3BD7-4360-B17E-A9571E6EAD3C', 2, 1433710800.0, 946715154.0, 'GMT+3', 1433710800.0, 946715714.0, 'GMT+3');"
            "INSERT INTO report VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946715714.0, 'GMT+3', 1433710800.0, 946721751.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946721751.0, 'GMT+3', 1433710800.0, 946722491.0, 'GMT+3');"
            "INSERT INTO report VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946722491.0, 'GMT+3', 1433710800.0, 946724911.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946724911.0, 'GMT+3', 1433710800.0, 946725353.0, 'GMT+3');"
            "INSERT INTO report VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946725353.0, 'GMT+3', 1433710800.0, 946728883.0, 'GMT+3');"
            "INSERT INTO report VALUES('819443B4-9302-4FEC-B839-71C311031D5D', 1, 1433710800.0, 946728883.0, 'GMT+3', 1433710800.0, 946729755.0, 'GMT+3');"
            "INSERT INTO report VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946729755.0, 'GMT+3', 1433710800.0, 946731007.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946731007.0, 'GMT+3', 1433710800.0, 946731929.0, 'GMT+3');"
            "INSERT INTO report VALUES('C0A7E530-29D0-4802-BA78-C64BA68644A5', 2, 1433710800.0, 946731929.0, 'GMT+3', 1433710800.0, 946733918.0, 'GMT+3');"
            "INSERT INTO report VALUES('2C93CA5C-81F2-4ABA-85D2-F4336A140163', 1, 1433710800.0, 946733918.0, 'GMT+3', 1433710800.0, 946733933.0, 'GMT+3');"
            "INSERT INTO report VALUES('6225C516-4430-46CF-83B4-0BBF1154F5AE', 2, 1433710800.0, 946733933.0, 'GMT+3', 1433710800.0, 946734627.0, 'GMT+3');"
            "INSERT INTO report VALUES('1A2C8C64-6E62-4499-B929-31F8119AECFE', 1, 1433710800.0, 946734627.0, 'GMT+3', 1433710800.0, 946734882.0, 'GMT+3');"
            "INSERT INTO report VALUES('E9317C01-AB26-4BBD-877B-791AC0FEEC98', 4, 1433710800.0, 946734882.0, 'GMT+3', 1433710800.0, 946739881.0, 'GMT+3');"
            "INSERT INTO report VALUES('A834C302-B257-4457-A150-9926B31F3B55', 1, 1433710800.0, 946739881.0, 'GMT+3', 1433710800.0, 946740835.0, 'GMT+3');"
            "INSERT INTO report VALUES('C0A7E530-29D0-4802-BA78-C64BA68644A5', 2, 1433710800.0, 946740835.0, 'GMT+3', 1433710800.0, 946742117.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946742117.0, 'GMT+3', 1433710800.0, 946747257.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946747257.0, 'GMT+3', 1433710800.0, 946748741.0, 'GMT+3');"
            "INSERT INTO report VALUES('204F401D-779E-4EC0-83C4-FCB6E5F9AC91', 1, 1433710800.0, 946748741.0, 'GMT+3', 1433710800.0, 946750598.0, 'GMT+3');"
            "INSERT INTO report VALUES('5FD84135-E587-4267-B803-40A7032B120E', 1, 1433710800.0, 946750598.0, 'GMT+3', 1433710800.0, 946754007.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946754007.0, 'GMT+3', 1433710800.0, 946760367.0, 'GMT+3');"
            "INSERT INTO report VALUES('4B4EB9DE-942A-489F-B2FD-FEE38627BBB3', 1, 1433710800.0, 946760367.0, 'GMT+3', 1433797200.0, 946674685.0, 'GMT+3');"
            "INSERT INTO report VALUES('EF73F78D-1C75-4505-92A1-C82A6DBE4805', 1, 1433797200.0, 946674685.0, 'GMT+3', 1433797200.0, 946675785.0, 'GMT+3');"
            "INSERT INTO report VALUES('DBE7A562-6E79-4C33-84A8-F74F5112CA05', 0, 1433797200.0, 946675785.0, 'GMT+3', 1433797200.0, 946705579.0, 'GMT+3');"
            "INSERT INTO report VALUES('014D1D81-40CC-44C2-96B8-4D6835F5C333', 1, 1433797200.0, 946705579.0, 'GMT+3', 1433797200.0, 946707120.0, 'GMT+3');"
            "INSERT INTO report VALUES('EF73F78D-1C75-4505-92A1-C82A6DBE4805', 1, 1433797200.0, 946707120.0, 'GMT+3', 1433797200.0, 946707497.0, 'GMT+3');"
            "INSERT INTO report VALUES('F5A1FA3E-D000-42DC-B02E-DF3D7EA773DC', 1, 1433797200.0, 946707497.0, 'GMT+3', 1433797200.0, 946707988.0, 'GMT+3');"
            "INSERT INTO report VALUES('BDB8FDB4-B81D-4893-BA42-3BE4E70AEAC2', 2, 1433797200.0, 946707988.0, 'GMT+3', 1433797200.0, 946709165.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433797200.0, 946709165.0, 'GMT+3', 1433797200.0, 946711780.0, 'GMT+3');"
            "INSERT INTO report VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433797200.0, 946711780.0, 'GMT+3', 1433797200.0, 946714884.0, 'GMT+3');"
            "INSERT INTO report VALUES('4B4EB9DE-942A-489F-B2FD-FEE38627BBB3', 1, 1433797200.0, 946714884.0, 'GMT+3', 1433797200.0, 946716558.0, 'GMT+3');"
            "INSERT INTO report VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433797200.0, 946716558.0, 'GMT+3', 1433797200.0, 946728283.0, 'GMT+3');"
            "INSERT INTO report VALUES('4B4EB9DE-942A-489F-B2FD-FEE38627BBB3', 1, 1433797200.0, 946728283.0, 'GMT+3', 1433797200.0, 946729652.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433797200.0, 946729652.0, 'GMT+3', 1433797200.0, 946731261.0, 'GMT+3');"
            "INSERT INTO report VALUES('2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433797200.0, 946731261.0, 'GMT+3', 1433797200.0, 946736059.0, 'GMT+3');"
            "INSERT INTO report VALUES('C0A7E530-29D0-4802-BA78-C64BA68644A5', 2, 1433797200.0, 946736059.0, 'GMT+3', 1433797200.0, 946737208.0, 'GMT+3');"
            "INSERT INTO report VALUES('1A2C8C64-6E62-4499-B929-31F8119AECFE', 1, 1433797200.0, 946737208.0, 'GMT+3', 1433797200.0, 946737432.0, 'GMT+3');"
            "INSERT INTO report VALUES('E10F8343-4922-4443-8552-9A56B9D47E65', 5, 1433797200.0, 946737432.0, 'GMT+3', 1433797200.0, 946744341.0, 'GMT+3');"
            "INSERT INTO report VALUES('7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433797200.0, 946744341.0, 'GMT+3', 1433797200.0, 946744967.0, 'GMT+3');"
            "INSERT INTO report VALUES('204F401D-779E-4EC0-83C4-FCB6E5F9AC91', 1, 1433797200.0, 946744967.0, 'GMT+3', 1433797200.0, 946746140.0, 'GMT+3');"
            "INSERT INTO report VALUES('5FD84135-E587-4267-B803-40A7032B120E', 1, 1433797200.0, 946746140.0, 'GMT+3', 1433797200.0, 946749185.0, 'GMT+3');"            ""];

    [database close];
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

    //[self createTestData];
}

- (void)clearCaches {
    [self.categoriesCache removeAllObjects];
    [self.dateSectionsCache removeAllObjects];
    [self.reportsExtendedBySectionCache removeAllObjects];
    [self.reportsExtendedCache removeAllObjects];
    [self.completionsCache removeAllObjects];
}

- (HTLActionDto *)getActionWithTitle:(NSString *)title database:(FMDatabase *)database {
    HTLActionDto *action;
    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM action WHERE title = :title LIMIT 1;"
                            withParameterDictionary:@{@"title" : title}];
    while ([resultSet next]) {
        action = [HTLActionDto actionWithIdentifier:[resultSet stringForColumn:@"identifier"]
                                              title:[resultSet stringForColumn:@"title"]];
    }
    [resultSet close];
    return action;
}

- (HTLCategoryDto *)getCategoryWithIdentifier:(HTLCategoryIdentifier)identifier database:(FMDatabase *)database {
    HTLCategoryDto *category;
    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM category WHERE identifier = :identifier LIMIT 1;"
                            withParameterDictionary:@{@"identifier" : identifier}];
    while ([resultSet next]) {
        category = [HTLCategoryDto categoryWithIdentifier:[resultSet stringForColumn:@"identifier"]
                                                    title:[resultSet stringForColumn:@"title"]
                                                    color:[UIColor colorWithHexString:[resultSet stringForColumn:@"color"]]];
    }
    [resultSet close];
    return category;
}

- (NSArray *)categoriesInDatabase:(FMDatabase *)database {
    NSMutableArray *categories = [NSMutableArray new];

    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM category;"];
    while ([resultSet next]) {
        HTLCategoryDto *category = [self categoryWithResultSet:resultSet];
        if (category) {
            [categories addObject:category];
        }
    }
    [resultSet close];
    return [categories copy];
}

- (NSArray *)categoriesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate inDatabase:(FMDatabase *)database {
    // TODO: Implement filtering by date

    NSMutableArray *categories = [NSMutableArray new];

    FMResultSet *resultSet = [database executeQuery:
                    @"SELECT "
                            "*, "
                            "(startDate + startTime) as startDateTime, "
                            "(endDate + endTime) as endDateTime "
                            "FROM category WHERE startDateTime >= :startDateTime AND endDateTime <= :endDateTime;"
                            withParameterDictionary:@{
                                    @"startDateTime" : @11,
                                    @"endDateTime" : @11
                            }];

    while ([resultSet next]) {
        HTLCategoryDto *category = [self categoryWithResultSet:resultSet];
        if (category) {
            [categories addObject:category];
        }
    }
    [resultSet close];
    return [categories copy];
}

- (BOOL)addCategory:(HTLCategoryDto *)category toDatabase:(FMDatabase *)database {
    BOOL success = [database executeUpdate:@"INSERT OR IGNORE INTO category VALUES (:identifier , :title , :color)"
                   withParameterDictionary:@{
                           @"identifier" : category.identifier,
                           @"title" : category.title,
                           @"color" : [UIColor hexStringFromRGBColor:category.color]
                   }];
    if (success) {
        DDLogVerbose(@"Category inserted: %@", category);
    } else {
        DDLogError(@"Category insertion failed: %@", category);
    }

    return success;
}

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        categoriesCache_ = [NSCache new];
        dateSectionsCache_ = [NSCache new];
        reportsExtendedBySectionCache_ = [NSCache new];
        reportsExtendedCache_ = [NSCache new];
        completionsCache_ = [NSCache new];
    }
    return self;
}

#pragma mark - HTLStorageProvider

- (BOOL)resetContent {
    [self clearCaches];
    NSError *error;
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:self.storageFilePath error:&error];
    if (error) {
        DDLogError(@"%@", error.localizedDescription);
    }
    return result;
}

- (NSArray *)categories {
    NSArray *cachedCategories = [self.categoriesCache objectForKey:kCategoriesCacheKey];
    if (cachedCategories) {
        return cachedCategories;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *categories = [self categoriesInDatabase:database];
    [database close];

    if (categories.count) {
        [self.categoriesCache setObject:categories forKey:kCategoriesCacheKey];
    }

    return categories;
}

- (NSArray *)categoriesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSArray *cachedCategories = [self.categoriesCache objectForKey:kCategoriesCacheKey];
    if (cachedCategories) {
        return cachedCategories;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSArray *categories = [self categoriesFromDate:fromDate toDate:toDate inDatabase:database];
    [database close];

    if (categories.count) {
        [self.categoriesCache setObject:categories forKey:kCategoriesCacheKey];
    }

    return categories;
}

- (BOOL)addCategory:(HTLCategoryDto *)category {
    if (!category) {
        return NO;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return NO;
    }

    [self clearCaches];
    [self addCategory:category toDatabase:database];
    [database close];

    return YES;
}

- (NSArray *)dateSections {
    NSArray *cachedDateSections = [self.dateSectionsCache objectForKey:kDateSectionsCacheKey];
    if (cachedDateSections) {
        return cachedDateSections;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSMutableArray *sections = [NSMutableArray new];

    FMResultSet *resultSet = [database executeQuery:@"SELECT "
            "endDate, "
            "endTime, "
            "endZone "
            "FROM report "
            "GROUP BY endDate "
            "ORDER BY endDate ASC;"];
    while ([resultSet next]) {
        HTLDateSectionDto *dateSection = [self dateSectionWithResultSet:resultSet];
        if (dateSection) {
            [sections addObject:dateSection];
        }
    }
    [resultSet close];
    [database close];

    NSArray *result = [NSArray arrayWithArray:sections];
    if (result.count) {
        [self.dateSectionsCache setObject:result forKey:kDateSectionsCacheKey];
    }

    return result;
}

- (NSArray *)reportsExtended {
    NSArray *cachedReportsExtended = [self.reportsExtendedCache objectForKey:kReportsExtendedCacheKey];
    if (cachedReportsExtended) {
        return cachedReportsExtended;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSMutableArray *reportsExtended = [NSMutableArray new];

    FMResultSet *resultSet = [database executeQuery:
            @"SELECT "
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

    while ([resultSet next]) {
        HTLReportExtendedDto *reportExtended = [self reportExtendedWithResultSet:resultSet];
        if (reportExtended) {
            [reportsExtended addObject:reportExtended];
        }
    }
    [resultSet close];
    [database close];

    NSArray *result = [NSArray arrayWithArray:reportsExtended];
    if (result.count) {
        [self.reportsExtendedCache setObject:result forKey:kReportsExtendedCacheKey];
    }

    return result;
}

- (NSArray *)reportsExtendedWithDateSection:(HTLDateSectionDto *)dateSection {
    NSArray *cached = [self.reportsExtendedBySectionCache objectForKey:@(dateSection.hash)];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Reports Extended for Date Section %@", dateSection);
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSMutableArray *reportsExtended = [NSMutableArray new];

    FMResultSet *resultSet = [database executeQuery:@"SELECT "
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
    while ([resultSet next]) {
        HTLReportExtendedDto *reportExtended = [self reportExtendedWithResultSet:resultSet];
        if (reportExtended) {
            [reportsExtended addObject:reportExtended];
        }
    }
    [resultSet close];
    [database close];

    NSArray *result = [NSArray arrayWithArray:reportsExtended];
    if (result.count) {
        [self.reportsExtendedBySectionCache setObject:result forKey:@(dateSection.hash)];
    }

    return result;
}

- (NSArray *)completionsForText:(NSString *)text {
    NSString *pattern = text ? text : @"";

    NSArray *cached = [self.completionsCache objectForKey:pattern];
    if (cached) {
        DDLogVerbose(@"Retrieving cached Completions for pattern %@", pattern);
        return cached;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

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
                    "WHERE action.title LIKE :titlePattern "
                    "GROUP BY action.title "
                    "ORDER BY weight DESC;"
                            withParameterDictionary:@{@"titlePattern" : [NSString stringWithFormat:@"%@%%", pattern]}];
    NSMutableArray *completions = [NSMutableArray new];
    while ([resultSet next]) {
        HTLCompletion *completion = [self completionWithResultSet:resultSet];
        if (completion) {
            [completions addObject:completion];
        }
    }
    [resultSet close];
    [database close];

    NSArray *result = [NSArray arrayWithArray:completions];
    if (result.count) {
        [self.reportsExtendedCache setObject:completions forKey:pattern];
    }

    return result;
}

- (BOOL)addReportExtended:(HTLReportExtendedDto *)reportExtended {
    if (!reportExtended) {
        return NO;
    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return NO;
    }

    [self clearCaches];

    // Action. Try to find existing action.
    HTLActionDto *existingAction = [self getActionWithTitle:reportExtended.action.title database:database];

    // Action. Insert new.
    BOOL success;
    if (!existingAction) {
        success = [database executeUpdate:@"INSERT OR IGNORE INTO action VALUES (?, ?)",
                                          reportExtended.action.identifier, reportExtended.action.title];
//        DDLogDebug(@"new action inserted: %@", success ? @"YES" : @"NO");
    }

    // Category. Try to find existing category;
    HTLCategoryDto *existingCategory = [self getCategoryWithIdentifier:reportExtended.category.identifier database:database];

    // Category. Insert new.
    if (!existingCategory) {
        success = [database executeUpdate:@"INSERT OR IGNORE INTO category VALUES (?, ?, ?)",
                                          reportExtended.category.identifier,
                                          reportExtended.category.title,
                                          [UIColor hexStringFromRGBColor:reportExtended.category.color]];
//        DDLogDebug(@"new category inserted: %@", success ? @"YES" : @"NO");
    }

    NSTimeInterval startDateInterval;
    NSTimeInterval startTimeInterval;
    NSString *startZoneComponentString;
    [reportExtended.startDate disassembleToDateInterval:&startDateInterval timeInterval:&startTimeInterval zone:&startZoneComponentString];

    NSTimeInterval endDateInterval;
    NSTimeInterval endTimeInterval;
    NSString *endZoneComponentString;
    [reportExtended.endDate disassembleToDateInterval:&endDateInterval timeInterval:&endTimeInterval zone:&endZoneComponentString];

    // Report. Insert new.
    success = [database executeUpdate:@"INSERT OR IGNORE INTO report VALUES (:actionIdentifier, :categoryIdentifier, :startDate, :startTime, :startZone, :endDate, :endTime, :endZone)"
              withParameterDictionary:@{
                      @"actionIdentifier" : existingAction ? existingAction.identifier : reportExtended.action.identifier,
                      @"categoryIdentifier" : existingCategory ? existingCategory.identifier : reportExtended.category.identifier,
                      @"startDate" : @(startDateInterval),
                      @"startTime" : @(startTimeInterval),
                      @"startZone" : startZoneComponentString,
                      @"endDate" : @(endDateInterval),
                      @"endTime" : @(endTimeInterval),
                      @"endZone" : endZoneComponentString,
              }];

    DDLogVerbose(@"report inserted: %@", success ? @"YES" : @"NO");

    [database close];

    return YES;
}

- (NSArray *)reportsExtendedWithCategory:(HTLCategoryDto *)category fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {

    // TODO: Cache
    // TODO: fromDate, toDate

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return @[];
    }

    NSMutableArray *reportsExtended = [NSMutableArray new];

    FMResultSet *resultSet = [database executeQuery:@"SELECT "
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
                    "WHERE report.categoryIdentifier = :categoryIdentifier "
                    "ORDER BY report.endDate ASC, report.endTime ASC "
                    ";"
                            withParameterDictionary:@{@"categoryIdentifier" : category.identifier}];
    while ([resultSet next]) {
        HTLActionDto *action = [HTLActionDto actionWithIdentifier:[resultSet stringForColumn:@"actionIdentifier"]
                                                            title:[resultSet stringForColumn:@"actionTitle"]];
        HTLCategoryDto *nextCategory = [HTLCategoryDto categoryWithIdentifier:[resultSet stringForColumn:@"categoryIdentifier"]
                                                                        title:[resultSet stringForColumn:@"categoryTitle"]
                                                                        color:[UIColor colorWithHexString:[resultSet stringForColumn:@"categoryColor"]]];

        NSDate *startDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"reportStartDate"]
                                            timeInterval:[resultSet doubleForColumn:@"reportStartTime"]
                                                    zone:[resultSet stringForColumn:@"reportStartZone"]];

        NSDate *endDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"reportEndDate"]
                                          timeInterval:[resultSet doubleForColumn:@"reportEndTime"]
                                                  zone:[resultSet stringForColumn:@"reportEndZone"]];

        HTLReportExtendedDto *reportExtended = [HTLReportExtendedDto reportWithAction:action
                                                                             category:nextCategory
                                                                            startDate:startDate
                                                                              endDate:endDate];
        if (reportExtended) {
            [reportsExtended addObject:reportExtended];
        }
    }
    [resultSet close];
    [database close];

    NSArray *result = [NSArray arrayWithArray:reportsExtended];
//    if (result.count) {
//        [self.reportsExtendedBySectionCache setObject:result forKey:@(index)];
//    }
//
    return result;
}

- (NSDate *)lastReportEndDate {
    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return nil;
    }

    FMResultSet *resultSet = [database executeQuery:
            @"SELECT "
                    "endDate, "
                    "endTime, "
                    "endZone "
                    "FROM report "
                    "ORDER BY endDate DESC, endTime DESC "
                    "LIMIT 1;"];

    NSDate *endDate;
    while ([resultSet next]) {
        endDate = [NSDate dateWithDateInterval:[resultSet doubleForColumn:@"endDate"]
                                  timeInterval:[resultSet doubleForColumn:@"endTime"]
                                          zone:[resultSet stringForColumn:@"endZone"]];
    }
    [resultSet close];
    [database close];

    return endDate;
}

- (HTLReportExtendedDto *)lastReportExtended {
//    NSArray *cachedReportsExtended = [self.reportsExtendedCache objectForKey:kReportsExtendedCacheKey];
//    if (cachedReportsExtended) {
//        return cachedReportsExtended;
//    }

    FMDatabase *database = self.databaseOpen;
    if (!database) {
        return nil;
    }

//    NSMutableArray *reportsExtended = [NSMutableArray new];
    HTLReportExtendedDto *result;

    FMResultSet *resultSet = [database executeQuery:
            @"SELECT "
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

    if ([resultSet next]) {
        result = [self reportExtendedWithResultSet:resultSet];
    }
    [resultSet close];
    [database close];

//    NSArray *result = [NSArray arrayWithArray:reportsExtended];
//    if (result.count) {
//        [self.reportsExtendedCache setObject:result forKey:kReportsExtendedCacheKey];
//    }

    return result;
}

@end

