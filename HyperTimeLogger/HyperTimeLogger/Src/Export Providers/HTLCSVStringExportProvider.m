//
// Created by Maxim Pervushin on 08/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCSVStringExportProvider.h"
#import "HTLMark.h"
#import "HTLReport.h"
#import "DDLogMacros.h"

static NSString *const kDefaultDateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";


@interface HTLCSVStringExportProvider()

- (NSDateFormatter *)defaultDateFormatter;

@end

@implementation HTLCSVStringExportProvider

- (NSDateFormatter *)defaultDateFormatter {
    static NSDateFormatter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSDateFormatter new];
        instance.dateFormat = kDefaultDateFormat;
    });
    return instance;
}

- (NSString *)exportReportsExtended:(NSArray *)reportsExtended {
    NSMutableString *csvString = [NSMutableString new];
//    for (HTLReportExtended *reportExtended in reportsExtended) {
//        if (![reportExtended isKindOfClass:[HTLReportExtended class]]) {
//            DDLogError(@"Invalid class: %@", reportExtended);
//            continue;
//        }
//
//        [csvString appendFormat:@"%@\t%@\t%@\t%@\n",
//                        [[self defaultDateFormatter] stringFromDate:reportExtended.report.startDate],
//                        [[self defaultDateFormatter] stringFromDate:reportExtended.report.endDate],
//                        reportExtended.action.title,
//                        NSLocalizedString(reportExtended.mark.title, nil)];
//    }
    return [csvString copy];
}

@end