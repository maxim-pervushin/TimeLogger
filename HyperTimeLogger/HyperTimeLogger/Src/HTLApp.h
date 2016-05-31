//
// Created by Maxim Pervushin on 31/05/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLDataManager;
@class HTLRemindersManager;


@interface HTLApp : NSObject

+ (NSString *)versionIdentifier;

+ (HTLDataManager *)dataManager;

+ (HTLRemindersManager *)remindersManager;

@end