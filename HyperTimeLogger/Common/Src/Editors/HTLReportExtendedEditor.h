//
// Created by Maxim Pervushin on 27/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLReportDto.h"

@class HTLReportExtendedDto;
@class HTLCategoryDto;
@class HTLActionDto;
@class HTLReportDto;


typedef void (^HTLReportExtendedEditorChangedBlock)();


@interface HTLReportExtendedEditor : NSObject

+ (instancetype)editorWithChangedBlock:(HTLReportExtendedEditorChangedBlock)block;

@property(nonatomic, strong) HTLReportExtendedDto *originalReportExtended;
@property(nonatomic, readonly) HTLReportExtendedDto *updatedReportExtended;

@property (nonatomic, readonly) BOOL canSave;

@property(nonatomic, strong) NSDate *reportStartDate;
@property(nonatomic, strong) NSDate *reportEndDate;
@property(nonatomic, strong) HTLActionDto *action;
@property(nonatomic, strong) HTLCategoryDto *category;

@end