//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDictionarySerialization.h"
#import "HTLReportDto.h"


static NSString *const kIdentifierKey = @"identifier";
static NSString *const kTitleKey = @"title";
static NSString *const kActionIdentifierKey = @"actionIdentifier";
static NSString *const kCategoryIdentifierKey = @"categoryIdentifier";
static NSString *const kDateKey = @"date";

static NSString *const kDefaultDateFormat = @"yyyy-MM-dd HH:mm:ss";


@implementation HTLDictionarySerialization

+ (NSDateFormatter *)defaultDateFormatter {
    static NSDateFormatter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSDateFormatter new];
        instance.dateFormat = kDefaultDateFormat;
    });
    return instance;
}

+ (HTLReportDto *)reportWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    HTLActionIdentifier actionIdentifier = dictionary[kActionIdentifierKey];
    HTLCategoryIdentifier categoryIdentifier = dictionary[kCategoryIdentifierKey];
    NSDate *date = [[self defaultDateFormatter] dateFromString:dictionary[kDateKey]];
    if (!actionIdentifier || !categoryIdentifier || !date) {
        return nil;
    }

    return [HTLReportDto reportWithActionIdentifier:actionIdentifier categoryIdentifier:categoryIdentifier startDate:nil endDate:date];
}

+ (NSDictionary *)dictionaryWithReport:(HTLReportDto *)report {
    if (![report isKindOfClass:[HTLReportDto class]]) {
        return nil;
    }

    NSString *dateString = [[self defaultDateFormatter] stringFromDate:report.endDate];
    if (!dateString || !report.actionIdentifier || !report.categoryIdentifier) {
        return nil;
    }

    return @{
            kActionIdentifierKey : report.actionIdentifier,
            kCategoryIdentifierKey : report.categoryIdentifier,
            kDateKey : dateString
    };
}

+ (HTLActionDto *)actionWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    HTLActionIdentifier identifier = dictionary[kIdentifierKey];
    NSString *title = dictionary[kTitleKey];
    if (!identifier || !title) {
        return nil;
    }

    return [HTLActionDto actionWithIdentifier:identifier title:title];
}

+ (NSDictionary *)dictionaryWithAction:(HTLActionDto *)action {
    if (![action isKindOfClass:[HTLActionDto class]]) {
        return nil;
    }

    if (!action.identifier || !action.title) {
        return nil;
    }

    return @{
            kIdentifierKey : action.identifier,
            kTitleKey : action.title
    };
}

@end