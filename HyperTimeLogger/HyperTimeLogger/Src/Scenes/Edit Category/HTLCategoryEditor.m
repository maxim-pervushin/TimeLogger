//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategoryEditor.h"


@implementation HTLCategoryEditor
@synthesize originalCategory = originalCategory_;
@dynamic canSave;
@dynamic updatedCategory;

- (void)setOriginalCategory:(HTLMark *)originalCategory {
    originalCategory_ = [originalCategory copy];
    self.title = [originalCategory_.title copy];
    self.subTitle = [originalCategory_.subtitle copy];
    self.color = originalCategory_.color;
}

- (BOOL)canSave {
    if (!self.title || !self.color) {
        return NO;
    }

    if (self.originalCategory && [self.originalCategory.title isEqual:self.title] && [self.originalCategory.subtitle isEqual:self.subTitle] && [self.originalCategory.color isEqual:self.color]) {
        return NO;
    }

    return YES;
}

- (HTLMark *)updatedCategory {
    if (!self.canSave) {
        return nil;
    }

    return [HTLMark markWithTitle:self.title subTitle:self.subTitle color:self.color];
}

@end