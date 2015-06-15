//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLActionDto;
@class HTLCategoryDto;
@class HTLReportDto;


@interface HTLReportExtendedDto : NSObject <NSCopying>

+ (instancetype)reportExtendedWithReport:(HTLReportDto *)report action:(HTLActionDto *)action category:(HTLCategoryDto *)category;

- (instancetype)initWithReport:(HTLReportDto *)report action:(HTLActionDto *)action category:(HTLCategoryDto *)category;

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToDto:(HTLReportExtendedDto *)dto;

- (NSUInteger)hash;

@property(nonatomic, readonly) HTLReportDto *report;
@property(nonatomic, readonly) HTLActionDto *action;
@property(nonatomic, readonly) HTLCategoryDto *category;

@end

