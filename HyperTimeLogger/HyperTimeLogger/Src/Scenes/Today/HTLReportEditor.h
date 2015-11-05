//
// Created by Maxim Pervushin on 04/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

@class HTLReport;
@class HTLMark;
@class HTLMarkEditor;

typedef void (^HTLEditorChangedBlock)();

@interface HTLReportEditor : NSObject

+ (instancetype)editorWithChangedBlock:(HTLEditorChangedBlock)block;

- (NSString *)description;

@property(nonatomic, readonly) HTLMarkEditor *markEditor;
@property(nonatomic, copy) NSDate *startDate;
@property(nonatomic, copy) NSDate *endDate;

@property(nonatomic, readonly) HTLReport *report;

@end;

