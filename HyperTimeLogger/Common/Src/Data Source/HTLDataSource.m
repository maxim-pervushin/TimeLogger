//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"

@interface HTLDataSource ()

@property(nonatomic, copy) HTLDataSourceChangedBlock contentChangedBlock;

@end

// TODO: Use HTLChangesObserver?

@implementation HTLDataSource

+ (instancetype)dataSourceWithContentChangedBlock:(HTLDataSourceChangedBlock)block {
    HTLDataSource *instance = [self new];
    if (block) {
        instance.contentChangedBlock = block;
    }
    return instance;
}

- (void)dataChanged {
    if (self.contentChangedBlock) {
        self.contentChangedBlock();
    }
}

@end