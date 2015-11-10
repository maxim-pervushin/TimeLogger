//
// Created by Maxim Pervushin on 04/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

@class HTLMark;

typedef void (^HTLEditorChangedBlock)();

@interface HTLMarkEditor: NSObject

+ (instancetype)editorWithChangedBlock:(HTLEditorChangedBlock)block;

- (NSString *)description;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property(nonatomic, copy) UIColor *color;

@property(nonatomic, copy) HTLMark *mark;

@end

