//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLAction;
@class HTLCategory;
@class HTLReport;


@interface HTLReportExtended : NSObject <NSCopying>

+ (instancetype)reportExtendedWithReport:(HTLReport *)report action:(HTLAction *)action category:(HTLCategory *)category;

- (id)copyWithZone:(nullable NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToExtended:(HTLReportExtended *)extended;

- (NSUInteger)hash;

- (NSString *)description;

@property(nonatomic, readonly) HTLReport *report;
@property(nonatomic, readonly) HTLAction *action;
@property(nonatomic, readonly) HTLCategory *category;

@end

