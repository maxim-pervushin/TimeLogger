//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^HTLDataSourceDataChangedBlock)();


@interface HTLDataSource : NSObject

+ (instancetype)dataSourceWithDataChangedBlock:(HTLDataSourceDataChangedBlock)block;

- (void)dataChanged;

@end
