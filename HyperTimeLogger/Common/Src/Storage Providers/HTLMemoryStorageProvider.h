//
// Created by Maxim Pervushin on 30/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStorageProvider.h"
#import "HTLChangesObserver.h"


@interface HTLMemoryStorageProvider : NSObject <HTLStorageProvider>

@property (nonatomic, weak) id<HTLChangesObserver> changesObserver;

@end