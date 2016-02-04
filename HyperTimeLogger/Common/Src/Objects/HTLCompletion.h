//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLAction;
@class HTLCategory;


@interface HTLCompletion : NSObject <NSCopying>

+ (instancetype)completionWithAction:(HTLAction *)action category:(HTLCategory *)category weight:(NSUInteger)weight;

- (instancetype)initWithAction:(HTLAction *)action category:(HTLCategory *)category weight:(NSUInteger)weight;

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToCompletion:(HTLCompletion *)completion;

- (NSUInteger)hash;

@property(nonatomic, readonly) HTLAction *action;
@property(nonatomic, readonly) HTLCategory *category;
@property(nonatomic, readonly) NSUInteger weight;

@end