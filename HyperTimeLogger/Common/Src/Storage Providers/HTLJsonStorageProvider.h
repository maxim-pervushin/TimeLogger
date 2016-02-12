//
// Created by Maxim Pervushin on 12/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStorageProvider.h"
#import "HTLChangesObserver.h"


@interface HTLJsonStorageProvider : NSObject <HTLStorageProvider>

+ (instancetype)jsonStorageProviderWithStorageFolderURL:(NSURL *)storageFolderURL storageFileName:(NSString *)storageFileName;

- (NSString *)storageFilePath;

@property (nonatomic, weak) id<HTLChangesObserver> changesObserver;

@end

