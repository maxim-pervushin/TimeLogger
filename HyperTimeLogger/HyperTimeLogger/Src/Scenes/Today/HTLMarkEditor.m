//
// Created by Maxim Pervushin on 04/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLMarkEditor.h"
#import "HTLMark.h"

@interface HTLMarkEditor () {
    NSString *_title;
    NSString *_subtitle;
    UIColor *_color;
}

@property(nonatomic, copy) HTLEditorChangedBlock changedBlock;

- (void)changed;

@end

@implementation HTLMarkEditor
@dynamic title;
@dynamic subtitle;
@dynamic color;
@dynamic mark;

+ (instancetype)editorWithChangedBlock:(HTLEditorChangedBlock)block {
    HTLMarkEditor *editor = [HTLMarkEditor new];
    if (block) {
        editor.changedBlock = block;
    }
    return editor;
}

- (NSString *)title {
    return _title;
}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = [title copy];
    } else {
        _title = nil;
    }
    [self changed];
}

- (NSString *)subtitle {
    return _subtitle;
}

- (void)setSubtitle:(NSString *)subtitle {
    if (subtitle) {
        _subtitle = [subtitle copy];
    } else {
        _subtitle = nil;
    }
    [self changed];
}

- (UIColor *)color {
    return _color;
}

- (void)setColor:(UIColor *)color {
    if (color) {
        _color = [color copy];
    } else {
        _color = nil;
    }
    [self changed];
}

- (void)setMark:(HTLMark *)mark {
    self.title = mark.title;
    self.subtitle = mark.subtitle;
    self.color = mark.color;
    [self changed];
}

- (HTLMark *)mark {
    if (self.title.length == 0 || !self.color) {
        return nil;
    }

    return [HTLMark markWithTitle:self.title subTitle:self.subtitle color:self.color];
}

- (void)changed {
    if (self.changedBlock) {
        self.changedBlock();
    }
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"_title=%@", _title];
    [description appendFormat:@", _subtitle=%@", _subtitle];
    [description appendFormat:@", _color=%@", _color];
    [description appendString:@">"];
    return description;
}

@end