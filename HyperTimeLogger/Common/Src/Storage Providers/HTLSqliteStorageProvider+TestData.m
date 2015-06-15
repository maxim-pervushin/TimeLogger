//
// Created by Maxim Pervushin on 15/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "FMDB.h"
#import "HTLSqliteStorageProvider.h"
#import "HTLSqliteStorageProvider+TestData.h"


@implementation HTLSqliteStorageProvider (TestData)

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
            "CREATE TABLE report(identifier TEXT PRIMARY KEY, actionIdentifier TEXT, categoryIdentifier TEXT, startDate REAL, startTime REAL, startZone TEXT, endDate REAL, endTime REAL, endZone TEXT);"
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
            "INSERT INTO report VALUES('0001A041-3CAD-46E9-B235-CDC183E4B9BA', '3198A041-3CAD-46E9-B235-CDC183E4B9BA', 4, 1433624400.0, 946742275.0, 'GMT+3', 1433624400.0, 946742275.0, 'GMT+3');"
            "INSERT INTO report VALUES('0002C233-D435-4658-A8F9-A217EB5ED4DA', '3482C233-D435-4658-A8F9-A217EB5ED4DA', 4, 1433624400.0, 946742275.0, 'GMT+3', 1433624400.0, 946742853.0, 'GMT+3');"
            "INSERT INTO report VALUES('00039FA6-8981-4B30-8ED6-3F86A9DD0F83', '4D759FA6-8981-4B30-8ED6-3F86A9DD0F83', 4, 1433624400.0, 946742853.0, 'GMT+3', 1433624400.0, 946749312.0, 'GMT+3');"
            "INSERT INTO report VALUES('000473EB-7950-41C4-9B15-D0352678008E', 'B81673EB-7950-41C4-9B15-D0352678008E', 1, 1433624400.0, 946749312.0, 'GMT+3', 1433624400.0, 946750096.0, 'GMT+3');"
            "INSERT INTO report VALUES('0005401D-779E-4EC0-83C4-FCB6E5F9AC91', '204F401D-779E-4EC0-83C4-FCB6E5F9AC91', 1, 1433624400.0, 946750096.0, 'GMT+3', 1433624400.0, 946751807.0, 'GMT+3');"
            "INSERT INTO report VALUES('00064135-E587-4267-B803-40A7032B120E', '5FD84135-E587-4267-B803-40A7032B120E', 1, 1433624400.0, 946751807.0, 'GMT+3', 1433624400.0, 946753516.0, 'GMT+3');"
            "INSERT INTO report VALUES('00078343-4922-4443-8552-9A56B9D47E65', 'E10F8343-4922-4443-8552-9A56B9D47E65', 5, 1433624400.0, 946753516.0, 'GMT+3', 1433624400.0, 946759258.0, 'GMT+3');"
            "INSERT INTO report VALUES('0008C302-B257-4457-A150-9926B31F3B55', 'A834C302-B257-4457-A150-9926B31F3B55', 1, 1433624400.0, 946759258.0, 'GMT+3', 1433710800.0, 946674607.0, 'GMT+3');"
            "INSERT INTO report VALUES('0009528E-4667-4384-9FD2-814B845FCA02', '14F3528E-4667-4384-9FD2-814B845FCA02', 1, 1433710800.0, 946674607.0, 'GMT+3', 1433710800.0, 946675381.0, 'GMT+3');"
            "INSERT INTO report VALUES('0010F78D-1C75-4505-92A1-C82A6DBE4805', 'EF73F78D-1C75-4505-92A1-C82A6DBE4805', 1, 1433710800.0, 946675381.0, 'GMT+3', 1433710800.0, 946675727.0, 'GMT+3');"
            "INSERT INTO report VALUES('0011A562-6E79-4C33-84A8-F74F5112CA05', 'DBE7A562-6E79-4C33-84A8-F74F5112CA05', 0, 1433710800.0, 946675727.0, 'GMT+3', 1433710800.0, 946700848.0, 'GMT+3');"
            "INSERT INTO report VALUES('0012672F-E59E-4764-A02D-F100C64A3427', '656D672F-E59E-4764-A02D-F100C64A3427', 1, 1433710800.0, 946700848.0, 'GMT+3', 1433710800.0, 946701273.0, 'GMT+3');"
            "INSERT INTO report VALUES('001377FD-B4B7-4940-9FC7-204D3BA39030', '67C977FD-B4B7-4940-9FC7-204D3BA39030', 1, 1433710800.0, 946701273.0, 'GMT+3', 1433710800.0, 946702231.0, 'GMT+3');"
            "INSERT INTO report VALUES('00141D81-40CC-44C2-96B8-4D6835F5C333', '014D1D81-40CC-44C2-96B8-4D6835F5C333', 1, 1433710800.0, 946702231.0, 'GMT+3', 1433710800.0, 946703105.0, 'GMT+3');"
            "INSERT INTO report VALUES('001587F3-040C-4E91-BAFB-A74949625C79', '3D7187F3-040C-4E91-BAFB-A74949625C79', 1, 1433710800.0, 946703105.0, 'GMT+3', 1433710800.0, 946703846.0, 'GMT+3');"
            "INSERT INTO report VALUES('0016F78D-1C75-4505-92A1-C82A6DBE4805', 'EF73F78D-1C75-4505-92A1-C82A6DBE4805', 1, 1433710800.0, 946703846.0, 'GMT+3', 1433710800.0, 946704293.0, 'GMT+3');"
            "INSERT INTO report VALUES('0017FA3E-D000-42DC-B02E-DF3D7EA773DC', 'F5A1FA3E-D000-42DC-B02E-DF3D7EA773DC', 1, 1433710800.0, 946704293.0, 'GMT+3', 1433710800.0, 946705207.0, 'GMT+3');"
            "INSERT INTO report VALUES('0018FDB4-B81D-4893-BA42-3BE4E70AEAC2', 'BDB8FDB4-B81D-4893-BA42-3BE4E70AEAC2', 2, 1433710800.0, 946705207.0, 'GMT+3', 1433710800.0, 946706260.0, 'GMT+3');"
            "INSERT INTO report VALUES('00195BE4-CDA9-4710-8FAE-7AD5FA015AB1', '09385BE4-CDA9-4710-8FAE-7AD5FA015AB1', 4, 1433710800.0, 946706260.0, 'GMT+3', 1433710800.0, 946707977.0, 'GMT+3');"
            "INSERT INTO report VALUES('0020008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946707977.0, 'GMT+3', 1433710800.0, 946710060.0, 'GMT+3');"
            "INSERT INTO report VALUES('002133CF-0BFF-4973-BAF9-B32D9506E319', '2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946710060.0, 'GMT+3', 1433710800.0, 946712441.0, 'GMT+3');"
            "INSERT INTO report VALUES('0022008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946712441.0, 'GMT+3', 1433710800.0, 946714434.0, 'GMT+3');"
            "INSERT INTO report VALUES('002333CF-0BFF-4973-BAF9-B32D9506E319', '2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946714434.0, 'GMT+3', 1433710800.0, 946715154.0, 'GMT+3');"
            "INSERT INTO report VALUES('0024DE33-3BD7-4360-B17E-A9571E6EAD3C', 'F388DE33-3BD7-4360-B17E-A9571E6EAD3C', 2, 1433710800.0, 946715154.0, 'GMT+3', 1433710800.0, 946715714.0, 'GMT+3');"
            "INSERT INTO report VALUES('002533CF-0BFF-4973-BAF9-B32D9506E319', '2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946715714.0, 'GMT+3', 1433710800.0, 946721751.0, 'GMT+3');"
            "INSERT INTO report VALUES('0026008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946721751.0, 'GMT+3', 1433710800.0, 946722491.0, 'GMT+3');"
            "INSERT INTO report VALUES('002733CF-0BFF-4973-BAF9-B32D9506E319', '2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946722491.0, 'GMT+3', 1433710800.0, 946724911.0, 'GMT+3');"
            "INSERT INTO report VALUES('0028008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946724911.0, 'GMT+3', 1433710800.0, 946725353.0, 'GMT+3');"
            "INSERT INTO report VALUES('002933CF-0BFF-4973-BAF9-B32D9506E319', '2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946725353.0, 'GMT+3', 1433710800.0, 946728883.0, 'GMT+3');"
            "INSERT INTO report VALUES('003043B4-9302-4FEC-B839-71C311031D5D', '819443B4-9302-4FEC-B839-71C311031D5D', 1, 1433710800.0, 946728883.0, 'GMT+3', 1433710800.0, 946729755.0, 'GMT+3');"
            "INSERT INTO report VALUES('003133CF-0BFF-4973-BAF9-B32D9506E319', '2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433710800.0, 946729755.0, 'GMT+3', 1433710800.0, 946731007.0, 'GMT+3');"
            "INSERT INTO report VALUES('0032008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946731007.0, 'GMT+3', 1433710800.0, 946731929.0, 'GMT+3');"
            "INSERT INTO report VALUES('0033E530-29D0-4802-BA78-C64BA68644A5', 'C0A7E530-29D0-4802-BA78-C64BA68644A5', 2, 1433710800.0, 946731929.0, 'GMT+3', 1433710800.0, 946733918.0, 'GMT+3');"
            "INSERT INTO report VALUES('0034CA5C-81F2-4ABA-85D2-F4336A140163', '2C93CA5C-81F2-4ABA-85D2-F4336A140163', 1, 1433710800.0, 946733918.0, 'GMT+3', 1433710800.0, 946733933.0, 'GMT+3');"
            "INSERT INTO report VALUES('0035C516-4430-46CF-83B4-0BBF1154F5AE', '6225C516-4430-46CF-83B4-0BBF1154F5AE', 2, 1433710800.0, 946733933.0, 'GMT+3', 1433710800.0, 946734627.0, 'GMT+3');"
            "INSERT INTO report VALUES('00368C64-6E62-4499-B929-31F8119AECFE', '1A2C8C64-6E62-4499-B929-31F8119AECFE', 1, 1433710800.0, 946734627.0, 'GMT+3', 1433710800.0, 946734882.0, 'GMT+3');"
            "INSERT INTO report VALUES('00377C01-AB26-4BBD-877B-791AC0FEEC98', 'E9317C01-AB26-4BBD-877B-791AC0FEEC98', 4, 1433710800.0, 946734882.0, 'GMT+3', 1433710800.0, 946739881.0, 'GMT+3');"
            "INSERT INTO report VALUES('0038C302-B257-4457-A150-9926B31F3B55', 'A834C302-B257-4457-A150-9926B31F3B55', 1, 1433710800.0, 946739881.0, 'GMT+3', 1433710800.0, 946740835.0, 'GMT+3');"
            "INSERT INTO report VALUES('0039E530-29D0-4802-BA78-C64BA68644A5', 'C0A7E530-29D0-4802-BA78-C64BA68644A5', 2, 1433710800.0, 946740835.0, 'GMT+3', 1433710800.0, 946742117.0, 'GMT+3');"
            "INSERT INTO report VALUES('0040008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946742117.0, 'GMT+3', 1433710800.0, 946747257.0, 'GMT+3');"
            "INSERT INTO report VALUES('0041008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946747257.0, 'GMT+3', 1433710800.0, 946748741.0, 'GMT+3');"
            "INSERT INTO report VALUES('0042401D-779E-4EC0-83C4-FCB6E5F9AC91', '204F401D-779E-4EC0-83C4-FCB6E5F9AC91', 1, 1433710800.0, 946748741.0, 'GMT+3', 1433710800.0, 946750598.0, 'GMT+3');"
            "INSERT INTO report VALUES('00434135-E587-4267-B803-40A7032B120E', '5FD84135-E587-4267-B803-40A7032B120E', 1, 1433710800.0, 946750598.0, 'GMT+3', 1433710800.0, 946754007.0, 'GMT+3');"
            "INSERT INTO report VALUES('0044008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433710800.0, 946754007.0, 'GMT+3', 1433710800.0, 946760367.0, 'GMT+3');"
            "INSERT INTO report VALUES('0045B9DE-942A-489F-B2FD-FEE38627BBB3', '4B4EB9DE-942A-489F-B2FD-FEE38627BBB3', 1, 1433710800.0, 946760367.0, 'GMT+3', 1433797200.0, 946674685.0, 'GMT+3');"
            "INSERT INTO report VALUES('0046F78D-1C75-4505-92A1-C82A6DBE4805', 'EF73F78D-1C75-4505-92A1-C82A6DBE4805', 1, 1433797200.0, 946674685.0, 'GMT+3', 1433797200.0, 946675785.0, 'GMT+3');"
            "INSERT INTO report VALUES('0047A562-6E79-4C33-84A8-F74F5112CA05', 'DBE7A562-6E79-4C33-84A8-F74F5112CA05', 0, 1433797200.0, 946675785.0, 'GMT+3', 1433797200.0, 946705579.0, 'GMT+3');"
            "INSERT INTO report VALUES('00481D81-40CC-44C2-96B8-4D6835F5C333', '014D1D81-40CC-44C2-96B8-4D6835F5C333', 1, 1433797200.0, 946705579.0, 'GMT+3', 1433797200.0, 946707120.0, 'GMT+3');"
            "INSERT INTO report VALUES('0049F78D-1C75-4505-92A1-C82A6DBE4805', 'EF73F78D-1C75-4505-92A1-C82A6DBE4805', 1, 1433797200.0, 946707120.0, 'GMT+3', 1433797200.0, 946707497.0, 'GMT+3');"
            "INSERT INTO report VALUES('0050FA3E-D000-42DC-B02E-DF3D7EA773DC', 'F5A1FA3E-D000-42DC-B02E-DF3D7EA773DC', 1, 1433797200.0, 946707497.0, 'GMT+3', 1433797200.0, 946707988.0, 'GMT+3');"
            "INSERT INTO report VALUES('0051FDB4-B81D-4893-BA42-3BE4E70AEAC2', 'BDB8FDB4-B81D-4893-BA42-3BE4E70AEAC2', 2, 1433797200.0, 946707988.0, 'GMT+3', 1433797200.0, 946709165.0, 'GMT+3');"
            "INSERT INTO report VALUES('0052008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433797200.0, 946709165.0, 'GMT+3', 1433797200.0, 946711780.0, 'GMT+3');"
            "INSERT INTO report VALUES('005333CF-0BFF-4973-BAF9-B32D9506E319', '2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433797200.0, 946711780.0, 'GMT+3', 1433797200.0, 946714884.0, 'GMT+3');"
            "INSERT INTO report VALUES('0054B9DE-942A-489F-B2FD-FEE38627BBB3', '4B4EB9DE-942A-489F-B2FD-FEE38627BBB3', 1, 1433797200.0, 946714884.0, 'GMT+3', 1433797200.0, 946716558.0, 'GMT+3');"
            "INSERT INTO report VALUES('005533CF-0BFF-4973-BAF9-B32D9506E319', '2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433797200.0, 946716558.0, 'GMT+3', 1433797200.0, 946728283.0, 'GMT+3');"
            "INSERT INTO report VALUES('0056B9DE-942A-489F-B2FD-FEE38627BBB3', '4B4EB9DE-942A-489F-B2FD-FEE38627BBB3', 1, 1433797200.0, 946728283.0, 'GMT+3', 1433797200.0, 946729652.0, 'GMT+3');"
            "INSERT INTO report VALUES('0057008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433797200.0, 946729652.0, 'GMT+3', 1433797200.0, 946731261.0, 'GMT+3');"
            "INSERT INTO report VALUES('005833CF-0BFF-4973-BAF9-B32D9506E319', '2A2033CF-0BFF-4973-BAF9-B32D9506E319', 3, 1433797200.0, 946731261.0, 'GMT+3', 1433797200.0, 946736059.0, 'GMT+3');"
            "INSERT INTO report VALUES('0059E530-29D0-4802-BA78-C64BA68644A5', 'C0A7E530-29D0-4802-BA78-C64BA68644A5', 2, 1433797200.0, 946736059.0, 'GMT+3', 1433797200.0, 946737208.0, 'GMT+3');"
            "INSERT INTO report VALUES('00608C64-6E62-4499-B929-31F8119AECFE', '1A2C8C64-6E62-4499-B929-31F8119AECFE', 1, 1433797200.0, 946737208.0, 'GMT+3', 1433797200.0, 946737432.0, 'GMT+3');"
            "INSERT INTO report VALUES('00618343-4922-4443-8552-9A56B9D47E65', 'E10F8343-4922-4443-8552-9A56B9D47E65', 5, 1433797200.0, 946737432.0, 'GMT+3', 1433797200.0, 946744341.0, 'GMT+3');"
            "INSERT INTO report VALUES('0062008D-7F8B-46B8-83C5-BCE36AC04375', '7E72008D-7F8B-46B8-83C5-BCE36AC04375', 6, 1433797200.0, 946744341.0, 'GMT+3', 1433797200.0, 946744967.0, 'GMT+3');"
            "INSERT INTO report VALUES('0063401D-779E-4EC0-83C4-FCB6E5F9AC91', '204F401D-779E-4EC0-83C4-FCB6E5F9AC91', 1, 1433797200.0, 946744967.0, 'GMT+3', 1433797200.0, 946746140.0, 'GMT+3');"
            "INSERT INTO report VALUES('00644135-E587-4267-B803-40A7032B120E', '5FD84135-E587-4267-B803-40A7032B120E', 1, 1433797200.0, 946746140.0, 'GMT+3', 1433797200.0, 946749185.0, 'GMT+3');"            ""];

    [database close];
}
@end