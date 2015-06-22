//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLStorageProvider.h"

@protocol HTLStringExportProvider;


@interface HTLContentManager : NSObject <HTLStorageProvider>

+ (instancetype)contentManagerWithStorageProvider:(id <HTLStorageProvider>)storageProvider exportProvider:(id <HTLStringExportProvider>)exportProvider;

- (NSString *)exportDataToCSV;

@end