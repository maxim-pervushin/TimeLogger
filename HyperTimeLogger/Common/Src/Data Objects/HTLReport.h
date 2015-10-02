//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLCategory.h"
#import "HTLAction.h"


typedef NSString *HTLReportIdentifier;


@interface HTLReport : NSObject <NSCopying>

+ (instancetype)reportWithIdentifier:(HTLReportIdentifier)identifier actionIdentifier:(HTLActionIdentifier)actionIdentifier categoryIdentifier:(HTLCategoryIdentifier)categoryIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (id)copyWithZone:(nullable NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToReport:(HTLReport *)report;

- (NSUInteger)hash;

- (NSString *)description;

@property(nonatomic, readonly) HTLReportIdentifier identifier;
@property(nonatomic, readonly) HTLActionIdentifier actionIdentifier;
@property(nonatomic, readonly) HTLCategoryIdentifier categoryIdentifier;
@property(nonatomic, readonly) NSDate *startDate;
@property(nonatomic, readonly) NSDate *endDate;

@end

