//
// Created by Maxim Pervushin on 15/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLSqliteStorageProvider.h"

@class FMResultSet;
@class HTLAction;
@class HTLCompletion;
@class HTLReport;

@interface HTLSqliteStorageProvider (Deserialization)

- (HTLAction *)unpackAction:(FMResultSet *)resultSet;

- (HTLCategory *)unpackCategory:(FMResultSet *)resultSet;

- (HTLDateSection *)unpackDateSection:(FMResultSet *)resultSet;

- (HTLReport *)unpackReport:(FMResultSet *)resultSet;

- (HTLReportExtended *)unpackReportExtended:(FMResultSet *)resultSet;

- (HTLCompletion *)unpackCompletion:(FMResultSet *)resultSet;

@end