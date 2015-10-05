//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsViewController_New.h"
#import "HTLSettingsDataSource+TestData.h"


@implementation HTLSettingsViewController_New

#pragma mark - HTLSettingsViewController_New @IB

- (IBAction)generateTestDataButtonAction:(id)sender {
    [[HTLSettingsDataSource new] generateTestData];
}

@end