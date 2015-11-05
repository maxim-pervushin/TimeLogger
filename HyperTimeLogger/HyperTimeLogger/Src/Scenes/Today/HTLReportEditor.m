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
    NSDate *_startDate;
    NSDate *_endDate;
}

@property(nonatomic, copy) HTLEditorChangedBlock changedBlock;

- (void)changed;

@end

@implementation HTLReportEditor
@dynamic markEditor;
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

- (NSDate *)startDate {
    return _startDate;
}

- (void)setStartDate:(NSDate *)startDate {
    if (startDate) {
        _startDate = [startDate copy];
    } else {
        _startDate = nil;
    }
    [self changed];
}

- (NSDate *)endDate {
    return _endDate;
}

- (void)setEndDate:(NSDate *)endDate {
    if (endDate) {
        _endDate = [endDate copy];
    } else {
        _endDate = nil;
    }
    [self changed];
}

- (HTLReport *)report {
    if (!self.markEditor.mark || !self.startDate || !self.endDate) {
        return nil;
    }

    return [HTLReport reportWithMark:self.markEditor.mark startDate:self.startDate endDate:self.endDate];
}

- (void)changed {
    if (self.changedBlock) {
        self.changedBlock();
    }
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"_markEditor=%@", _markEditor];
    [description appendFormat:@", _startDate=%@", _startDate];
    [description appendFormat:@", _endDate=%@", _endDate];
    [description appendString:@">"];
    return description;
}


@end;

