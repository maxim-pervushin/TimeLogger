//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportDateListDataSource.h"
#import "HTLDateSection.h"
#import "HTLAppDelegate.h"
#import "HTLContentManager.h"


@implementation HTLReportDateListDataSource

- (NSUInteger)numberOfDateSections {
    return HTLAppContentManger.numberOfReportSections;
}

- (HTLDateSection *)dateSectionAtIndexPath:(NSIndexPath *)indexPath {
    return HTLAppContentManger.reportSections[(NSUInteger) indexPath.row];
}

@end