//
// Created by Maxim Pervushin on 30/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTLChangesObserver <NSObject>

- (void)changed:(id)id;

@end