//
// Created by Maxim Pervushin on 04/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTLSettingsModelController : NSObject

- (BOOL)resetContent;

- (BOOL)resetDefaults;

- (NSString *)exportDataToCSV;

@end
