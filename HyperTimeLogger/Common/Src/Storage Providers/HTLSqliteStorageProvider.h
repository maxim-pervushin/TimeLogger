//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStorageProvider.h"


@interface HTLSqliteStorageProvider : NSObject <HTLStorageProvider>

- (NSString *)storageFilePath;

@end

