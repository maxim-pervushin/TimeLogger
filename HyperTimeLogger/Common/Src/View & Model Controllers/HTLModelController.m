//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLModelController.h"

@interface HTLModelController ()

@property(nonatomic, copy) HTLModelControllerContentChangedBlock contentChangedBlock;

@end


@implementation HTLModelController

+ (instancetype)modelControllerWithContentChangedBlock:(HTLModelControllerContentChangedBlock)block {
    HTLModelController *instance = [self new];
    if (block) {
        instance.contentChangedBlock = block;
    }
    return instance;
}

- (void)contentChanged {
    if (self.contentChangedBlock) {
        self.contentChangedBlock();
    }
}

@end