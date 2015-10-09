//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLActivity.h"


typedef NSString *HTLReportIdentifier;

@interface HTLReport : NSObject <NSCopying, NSObject>

+ (instancetype)reportWithCategory:(HTLActivity *)category startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@property(nonatomic, readonly) HTLActivity *category;
@property(nonatomic, readonly) NSDate *startDate;
@property(nonatomic, readonly) NSDate *endDate;

@end

