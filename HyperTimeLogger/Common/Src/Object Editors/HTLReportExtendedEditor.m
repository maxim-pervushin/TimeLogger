//
// Created by Maxim Pervushin on 27/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import "HTLReportExtendedEditor.h"
#import "HTLReportExtended.h"

@interface HTLReportExtendedEditor () {
    HTLReportExtended *_originalReportExtended;
    NSDate *_reportStartDate;
    NSDate *_reportEndDate;
    HTLAction *_action;
    HTLCategory *_category;
}

@property(nonatomic, copy) HTLReportExtendedEditorChangedBlock changedBlock;

@end

@implementation HTLReportExtendedEditor
@dynamic canSave;

+ (instancetype)editorWithChangedBlock:(HTLReportExtendedEditorChangedBlock)block {
    HTLReportExtendedEditor *instance = [self new];
    if (block) {
        instance.changedBlock = block;
    }
    return instance;
}

- (void)setOriginalReportExtended:(HTLReportExtended *)originalReportExtended {
    _originalReportExtended = originalReportExtended;
    _reportStartDate = originalReportExtended.report.startDate;
    _reportEndDate = originalReportExtended.report.endDate;
    _action = originalReportExtended.action;
    _category = originalReportExtended.category;
    [self changed];
}

- (HTLReportExtended *)updatedReportExtended {
    if (!_reportStartDate || !_reportEndDate || !_action || !_category) {
        // Invalid data
        return nil;
    }

    HTLReportIdentifier reportIdentifier = nil;
    if (_originalReportExtended) {
        if ([_originalReportExtended.action isEqual:_action]
                && [_originalReportExtended.category isEqual:_category]
                && [_originalReportExtended.report.startDate isEqual:_reportStartDate]
                && [_originalReportExtended.report.endDate isEqual:_reportEndDate]) {
            // Nothing changed.
            return nil;
        }

        reportIdentifier = _originalReportExtended.report.identifier;
    }

    if (!reportIdentifier) {
        reportIdentifier = [NSUUID UUID].UUIDString;
    }

    HTLReport *report = [HTLReport reportWithIdentifier:reportIdentifier
                                       actionIdentifier:_action.identifier
                                     categoryIdentifier:_category.identifier
                                              startDate:_reportStartDate
                                                endDate:_reportEndDate];

    return [HTLReportExtended reportExtendedWithReport:report
                                                action:_action
                                              category:_category];
}

- (BOOL)canSave {
    return self.updatedReportExtended != nil;
}

- (void)setReportStartDate:(NSDate *)reportStartDate {
    _reportStartDate = reportStartDate;
    [self changed];
}

- (void)setReportEndDate:(NSDate *)reportEndDate {
    _reportEndDate = reportEndDate;
    [self changed];
}

- (void)setAction:(HTLAction *)action {
    _action = action;
    [self changed];
}

- (void)setCategory:(HTLCategory *)category {
    _category = category;
    [self changed];
}

- (void)changed {
    if (self.changedBlock) {
        self.changedBlock();
    }
}

@end