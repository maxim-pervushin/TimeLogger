//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTLCompletion;


@interface HTLCompletionCollectionViewCell : UICollectionViewCell

- (void)configureWithCompletion:(HTLCompletion *)completion;

@end