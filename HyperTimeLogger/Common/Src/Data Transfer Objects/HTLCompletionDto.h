//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLActionDto;
@class HTLCategoryDto;


@interface HTLCompletionDto : NSObject <NSCopying>

+ (instancetype)completionWithAction:(HTLActionDto *)action category:(HTLCategoryDto *)category weight:(NSUInteger)weight;

- (instancetype)initWithAction:(HTLActionDto *)action category:(HTLCategoryDto *)category weight:(NSUInteger)weight;

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToCompletion:(HTLCompletionDto *)completion;

- (NSUInteger)hash;

@property(nonatomic, readonly) HTLActionDto *action;
@property(nonatomic, readonly) HTLCategoryDto *category;
@property(nonatomic, readonly) NSUInteger weight;

@end