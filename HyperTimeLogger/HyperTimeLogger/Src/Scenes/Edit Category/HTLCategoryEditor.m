//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategoryEditor.h"
#import "HTLCategory.h"


@implementation HTLCategoryEditor
@synthesize originalCategory = originalCategory_;
@dynamic canSave;
@dynamic updatedCategory;

- (void)setOriginalCategory:(HTLCategory *)originalCategory {
    originalCategory_ = [originalCategory copy];
    self.identifier = [originalCategory_.identifier copy];
    self.title = [originalCategory_.title copy];
    self.color = originalCategory_.color;
}

- (BOOL)canSave {
    if (!self.title || !self.color) {
        return NO;
    }

    if (self.originalCategory && [self.originalCategory.title isEqual:self.title] && [self.originalCategory.color isEqual:self.color]) {
        return NO;
    }

    return YES;
}

- (HTLCategory *)updatedCategory {
    if (!self.canSave) {
        return nil;
    }

    return [HTLCategory categoryWithIdentifier:self.originalCategory ? self.originalCategory.identifier : [NSUUID new].UUIDString
                                         title:self.title
                                         subTitle:self.subTitle
                                         color:self.color];
}

@end