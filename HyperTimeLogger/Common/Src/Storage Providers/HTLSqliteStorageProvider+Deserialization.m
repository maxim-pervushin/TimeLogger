//
// Created by Maxim Pervushin on 15/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReport.h"
#import "HTLDateSection.h"
#import "NSDate+HTLComponents.h"
#import "HexColor.h"
#import "FMDB.h"
#import "HTLSqliteStorageProvider.h"
#import "HTLSqliteStorageProvider+Deserialization.h"


@implementation HTLSqliteStorageProvider (Deserialization)

- (HTLActivity *)unpackActivity:(FMResultSet *)resultSet {
    return [HTLActivity categoryWithTitle:[resultSet stringForColumn:@"categoryTitle"]
                                 subTitle:[resultSet stringForColumn:@"categorySubTitle"]
                                    color:[UIColor colorWithHexString:[resultSet stringForColumn:@"categoryColor"]]];
}

- (HTLDateSection *)unpackDateSection:(FMResultSet *)resultSet {
    return [HTLDateSection dateSectionWithDateString:[resultSet stringForColumn:@"endDate"]
                                          timeString:[resultSet stringForColumn:@"endTime"]
                                            timeZone:[resultSet stringForColumn:@"endZone"]];
}

- (HTLReport *)unpackReport:(FMResultSet *)resultSet {

    NSDate *startDate = [NSDate dateWithDateString:[resultSet stringForColumn:@"startDate"]
                                        timeString:[resultSet stringForColumn:@"startTime"]
                                    timeZoneString:[resultSet stringForColumn:@"startZone"]];

    NSDate *endDate = [NSDate dateWithDateString:[resultSet stringForColumn:@"endDate"]
                                      timeString:[resultSet stringForColumn:@"endTime"]
                                  timeZoneString:[resultSet stringForColumn:@"endZone"]];

    HTLActivity *category = [self unpackActivity:resultSet];

    return [HTLReport reportWithCategory:category startDate:startDate endDate:endDate];
}

@end