//
// Created by Maxim Pervushin on 30/05/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HTLRemindersManager : NSObject

@property(assign, getter=isEnabled) BOOL enabled;

@property(assign) NSTimeInterval interval;

- (void)reload;

@end