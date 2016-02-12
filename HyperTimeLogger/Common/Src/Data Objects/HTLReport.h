//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLMark.h"


@interface HTLReport : NSObject <NSCopying, NSObject>

+ (instancetype)reportWithIdentifier:(NSString *)identifier mark:(HTLMark *)mark startDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (instancetype)reportWithMark:(HTLMark *)mark startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@property(nonatomic, readonly) NSString *identifier;
@property(nonatomic, readonly) HTLMark *mark;
@property(nonatomic, readonly) NSDate *startDate;
@property(nonatomic, readonly) NSDate *endDate;

@end

