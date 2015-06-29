//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSString *HTLActionIdentifier;


@interface HTLActionDto : NSObject <NSCopying>

+ (instancetype)actionWithIdentifier:(HTLActionIdentifier)identifier title:(NSString *)title;

- (instancetype)initWithIdentifier:(HTLActionIdentifier)identifier title:(NSString *)title;

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToAction:(HTLActionDto *)action;

- (NSUInteger)hash;

@property(nonatomic, readonly) HTLActionIdentifier identifier;
@property(nonatomic, readonly) NSString *title;

@end