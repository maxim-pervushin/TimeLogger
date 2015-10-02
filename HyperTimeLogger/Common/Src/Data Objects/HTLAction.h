//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSString *HTLActionIdentifier;


@interface HTLAction : NSObject <NSCopying>

+ (instancetype)actionWithIdentifier:(HTLActionIdentifier)identifier title:(NSString *)title;

- (id)copyWithZone:(nullable NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToAction:(HTLAction *)action;

- (NSUInteger)hash;

- (NSString *)description;

@property(nonatomic, readonly) HTLActionIdentifier identifier;
@property(nonatomic, readonly) NSString *title;

@end