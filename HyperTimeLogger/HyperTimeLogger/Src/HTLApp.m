//
// Created by Maxim Pervushin on 31/05/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import "HTLApp.h"
#import "HTLAppDelegate.h"
#import "HTLRemindersManager.h"
#import "HTLDataManager.h"


@implementation HTLApp

+ (NSString *)versionIdentifier {
    return [[self appDelegate] versionIdentifier];
}

+ (HTLDataManager *)dataManager {
    return [[self appDelegate] dataManager];
}

+ (HTLRemindersManager *)remindersManager {
    return [[self appDelegate] remindersManager];
}

+ (HTLAppDelegate *)appDelegate {
    return (HTLAppDelegate *)[UIApplication sharedApplication].delegate;
}

@end