//
// Created by Maxim Pervushin on 08/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTLStringExportProvider <NSObject>

- (NSString *)exportReportsExtended:(NSArray *)reportsExtended;

@end