//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^HTLDataSourceChangedBlock)();


@interface HTLDataSource : NSObject

+ (instancetype)dataSourceWithContentChangedBlock:(HTLDataSourceChangedBlock)block;

- (void)dataChanged;

@end
