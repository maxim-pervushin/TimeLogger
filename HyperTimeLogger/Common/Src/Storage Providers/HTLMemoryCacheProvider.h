//
// Created by Maxim Pervushin on 12/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStorageProvider.h"
#import "HTLChangesObserver.h"

@interface HTLMemoryCacheProvider : NSObject <HTLStorageProvider, HTLChangesObserver>

+ (instancetype)memoryCacheProviderWithStorageProvider:(id <HTLStorageProvider>)storageProvider;

@property (nonatomic, weak) id<HTLChangesObserver> changesObserver;

@end
