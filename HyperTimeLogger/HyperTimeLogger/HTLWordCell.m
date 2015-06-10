//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLWordCell.h"

@interface HTLWordCell ()

@property(nonatomic, weak) IBOutlet UILabel *wordLabel;

@end

@implementation HTLWordCell

- (void)configureWithWord:(NSString *)word {
    self.wordLabel.text = word;
}

@end