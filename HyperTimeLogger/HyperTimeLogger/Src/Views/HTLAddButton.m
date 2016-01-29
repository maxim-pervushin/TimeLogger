//
// Created by Maxim Pervushin on 08/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLAddButton.h"


@implementation HTLAddButton

- (void)configure {
    [super configure];

    [self setBackgroundColor:[UIColor paperColorBlue]];
    [self setTintColor:[UIColor whiteColor]];
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateSelected];
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
//}


//override public func drawRect(rect: CGRect) {
//    super.drawRect(rect)
//    layer.cornerRadius = min(frame.width, frame.height) / 2
//    for view in subviews {
//        view.layer.cornerRadius = min(frame.width, frame.height) / 2
//    }
//}


@end