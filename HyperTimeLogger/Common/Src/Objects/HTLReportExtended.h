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

- (instancetype)initWithReport:(HTLReport *)report action:(HTLAction *)action category:(HTLCategory *)category;

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToDto:(HTLReportExtended *)dto;

- (NSUInteger)hash;

@property(nonatomic, readonly) HTLReport *report;
@property(nonatomic, readonly) HTLAction *action;
@property(nonatomic, readonly) HTLCategory *category;

@end

