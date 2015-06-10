//
// Created by Maxim Pervushin on 04/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsModelController.h"
#import "HTLContentManager.h"

@implementation HTLSettingsModelController

- (BOOL)resetContent {
    return [[HTLContentManager defaultManager] resetContent];
}

- (BOOL)resetDefaults {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"self.addButtonToBottomLayoutConstraint.constant"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"self.addButtonToRightLayoutConstraint.constant"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // TODO: Send notification.

    return YES;
}

- (NSString *)exportDataToCSV {
    return [[HTLContentManager defaultManager] exportDataToCSV];
}

@end