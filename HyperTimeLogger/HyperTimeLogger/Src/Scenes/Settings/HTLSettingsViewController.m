//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsViewController.h"
#import "HTLSettingsDataSource.h"


@interface HTLSettingsViewController ()

@property (nonatomic, strong, readonly) HTLSettingsDataSource *dataSource;

@end

@implementation HTLSettingsViewController
@synthesize dataSource = dataSource_;

#pragma mark - HTLSettingsViewController_New @IB

- (IBAction)generateTestDataButtonAction:(id)sender {
    [self.dataSource generateTestData];
}

#pragma mark - HTLSettingsViewController_New

- (HTLSettingsDataSource *)dataSource {
    if (!dataSource_) {
        dataSource_ = [HTLSettingsDataSource new];
    }
    return dataSource_;
}

@end