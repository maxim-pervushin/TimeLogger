//
// Created by Maxim Pervushin on 27/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLReport.h"

@class HTLReportExtended;
@class HTLCategory;
@class HTLAction;
@class HTLReport;


typedef void (^HTLReportExtendedEditorChangedBlock)();


@interface HTLReportExtendedEditor : NSObject

+ (instancetype)editorWithChangedBlock:(HTLReportExtendedEditorChangedBlock)block;

@property(nonatomic, strong) HTLReportExtended *originalReportExtended;
@property(nonatomic, readonly) HTLReportExtended *updatedReportExtended;

@property (nonatomic, readonly) BOOL canSave;

@property(nonatomic, strong) NSDate *reportStartDate;
@property(nonatomic, strong) NSDate *reportEndDate;
@property(nonatomic, strong) HTLAction *action;
@property(nonatomic, strong) HTLCategory *category;

@end