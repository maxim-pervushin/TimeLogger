//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLMarkListDataSource.h"
#import "HTLMark.h"
#import "HTLAppDelegate.h"
#import "HTLContentManager.h"


@implementation HTLMarkListDataSource

- (NSUInteger)numberOfMandatoryCategories {
    return HTLAppContentManger.mandatoryMarks.count;
}

- (NSUInteger)numberOfCustomCategories {
    return HTLAppContentManger.customMarks.count;
}

- (HTLMark *)mandatoryMarkAtIndexPath:(NSIndexPath *)indexPath {
    return HTLAppContentManger.mandatoryMarks[(NSUInteger) indexPath.row];
}

- (HTLMark *)customMarkAtIndexPath:(NSIndexPath *)indexPath {
    return HTLAppContentManger.customMarks[(NSUInteger) indexPath.row];
}

- (BOOL)deleteCustomCategoryAtIndexPath:(NSIndexPath *)indexPath {
    return [HTLAppContentManger deleteMark:[self customMarkAtIndexPath:indexPath]];
}

- (BOOL)saveCategory:(HTLMark *)category {
    return [HTLAppContentManger saveMark:category];
}

@end