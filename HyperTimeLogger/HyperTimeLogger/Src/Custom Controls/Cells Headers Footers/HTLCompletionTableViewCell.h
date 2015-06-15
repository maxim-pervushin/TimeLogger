//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTLCompletionDto;


@interface HTLCompletionTableViewCell : UITableViewCell

- (void)configureWithCompletion:(HTLCompletionDto *)completion;

@end