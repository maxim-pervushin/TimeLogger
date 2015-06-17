//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^HTLModelControllerContentChangedBlock)();


@interface HTLModelController : NSObject

+ (instancetype)modelControllerWithContentChangedBlock:(HTLModelControllerContentChangedBlock)block;

- (void)contentChanged;

@end
