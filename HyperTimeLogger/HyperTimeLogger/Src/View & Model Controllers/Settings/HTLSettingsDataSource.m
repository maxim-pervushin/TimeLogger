//
// Created by Maxim Pervushin on 04/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsDataSource.h"
#import "HTLDataManager.h"
#import "HTLAppDelegate.h"

@implementation HTLSettingsDataSource

- (BOOL)resetContent {
    return [HTLAppDataManger clear];
}

- (BOOL)resetDefaults {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"self.addButtonToBottomLayoutConstraint.constant"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"self.addButtonToLeftLayoutConstraint.constant"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return YES;
}

- (NSString *)exportDataToCSV {
    return [HTLAppDataManger exportDataToCSV];
}

@end

