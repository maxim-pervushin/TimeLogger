//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTLDateSectionDto : NSObject <NSCopying>

+ (instancetype)dateSectionWithDate:(NSTimeInterval)date time:(NSTimeInterval)time zone:(NSString *)zone;

- (instancetype)initWithDate:(NSTimeInterval)date time:(NSTimeInterval)time zone:(NSString *)zone;

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToDto:(HTLDateSectionDto *)dto;

- (NSUInteger)hash;

- (NSString *)description;

@property (nonatomic, readonly) NSTimeInterval date;
@property (nonatomic, readonly) NSTimeInterval time;
@property (nonatomic, readonly) NSString *zone;

@end