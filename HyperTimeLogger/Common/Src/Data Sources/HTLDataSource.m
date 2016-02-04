//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDataSource.h"

@interface HTLDataSource ()

@property(nonatomic, copy) HTLDataSourceDataChangedBlock dataChangedBlock;

@end


@implementation HTLDataSource

+ (instancetype)dataSourceWithDataChangedBlock:(HTLDataSourceDataChangedBlock)block {
    HTLDataSource *instance = [self new];
    if (block) {
        instance.dataChangedBlock = block;
    }
    return instance;
}

- (void)dataChanged {
    if (self.dataChangedBlock) {
        self.dataChangedBlock();
    }
}

@end