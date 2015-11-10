//
// Created by Maxim Pervushin on 04/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportEditor.h"
#import "HTLMark.h"
#import "HTLReport.h"
#import "HTLMarkEditor.h"

@interface HTLReportEditor () {
    HTLMarkEditor *_markEditor;
    NSString *_identifier;
    NSDate *_startDate;
    NSDate *_endDate;
}

@property(nonatomic, copy) HTLEditorChangedBlock changedBlock;

- (void)changed;

@end

@implementation HTLReportEditor
@dynamic markEditor;
@dynamic identifier;
@dynamic startDate;
@dynamic endDate;
@dynamic report;

+ (instancetype)editorWithChangedBlock:(HTLEditorChangedBlock)block {
    HTLReportEditor *editor = [HTLReportEditor new];
    if (block) {
        editor.changedBlock = block;
    }
    return editor;
}

- (HTLMarkEditor *)markEditor {
    if (!_markEditor) {
        __weak __typeof(self) weakSelf = self;
        _markEditor = [HTLMarkEditor editorWithChangedBlock:^{
            [weakSelf changed];
        }];
    }
    return _markEditor;
}

- (NSString *)identifier {
    return _identifier;
}

- (void)setIdentifier:(NSString *)identifier {
    if (![_identifier isEqual:identifier]) {
        _identifier = [identifier copy];
    }
    [self changed];
}

- (NSDate *)startDate {
    return _startDate;
}

- (void)setStartDate:(NSDate *)startDate {
    if (![_startDate isEqual:startDate]) {
        _startDate = [startDate copy];
    }
    [self changed];
}

- (NSDate *)endDate {
    return _endDate;
}

- (void)setEndDate:(NSDate *)endDate {
    if (![_endDate isEqual:endDate]) {
        _endDate = [endDate copy];
    }
    [self changed];
}

- (void)setReport:(HTLReport *)report {
    self.markEditor.mark = report.mark;
    self.identifier = report.identifier;
    self.startDate = report.startDate;
    self.endDate = report.endDate;
    [self changed];
}

- (HTLReport *)report {
    if (!self.markEditor.mark || !self.startDate || !self.endDate) {
        return nil;
    }

    if (self.identifier.length == 0) {
        return [HTLReport reportWithMark:self.markEditor.mark startDate:self.startDate endDate:self.endDate];
    } else {
        return [HTLReport reportWithIdentifier:self.identifier mark:self.markEditor.mark startDate:self.startDate endDate:self.endDate];
    }
}

- (void)changed {
    if (self.changedBlock) {
        self.changedBlock();
    }
}

@end;

