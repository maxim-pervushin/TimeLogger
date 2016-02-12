//
// Created by Maxim Pervushin on 18/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStorageProvider.h"
#import "HTLChangesObserver.h"


static NSString *const kReportParseClassName = @"Report";

static NSString *const kMarkParseClassName = @"Mark";

@interface HTLParseStorageProvider : NSObject <HTLStorageProvider>

+ (instancetype)parseStorageProviderWithApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;

@property (nonatomic, weak) id<HTLChangesObserver> changesObserver;

@end