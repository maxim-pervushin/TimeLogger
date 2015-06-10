//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLReportDto;
@class HTLActionDto;


@interface HTLDictionarySerialization : NSObject

+ (HTLReportDto *)reportWithDictionary:(NSDictionary *)dictionary;

+ (NSDictionary *)dictionaryWithReport:(HTLReportDto *)report;

+ (HTLActionDto *)actionWithDictionary:(NSDictionary *)dictionary;

+ (NSDictionary *)dictionaryWithAction:(HTLActionDto *)action;

@end