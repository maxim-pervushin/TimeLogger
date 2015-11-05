//
// Created by Maxim Pervushin on 15/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLSqliteStorageProvider.h"

@class FMResultSet;
@class HTLReport;

@interface HTLSqliteStorageProvider (Deserialization)

- (HTLMark *)unpackActivity:(FMResultSet *)resultSet;

- (HTLDateSection *)unpackDateSection:(FMResultSet *)resultSet;

- (HTLReport *)unpackReport:(FMResultSet *)resultSet;

@end