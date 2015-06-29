//
// Created by Maxim Pervushin on 04/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsModelController.h"
#import "HTLContentManager.h"
#import "HTLAppDelegate.h"

@implementation HTLSettingsModelController

- (BOOL)resetContent {
    return [HTLAppContentManger clear];
}

- (BOOL)resetDefaults {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"self.addButtonToBottomLayoutConstraint.constant"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"self.addButtonToRightLayoutConstraint.constant"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return YES;
}

- (NSString *)exportDataToCSV {
    return [HTLAppContentManger exportDataToCSV];
}

@end

