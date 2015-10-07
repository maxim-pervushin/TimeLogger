//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLCategory.h"


typedef NSString *HTLReportIdentifier;

@interface HTLReport : NSObject <NSCopying, NSObject>

+ (instancetype)reportWithCategory:(HTLCategory *)category startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (id)copyWithZone:(nullable NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToReport:(HTLReport *)report;

- (NSUInteger)hash;

- (NSString *)description;

@property(nonatomic, readonly) HTLCategory *category;
@property(nonatomic, readonly) NSDate *startDate;
@property(nonatomic, readonly) NSDate *endDate;

@end

