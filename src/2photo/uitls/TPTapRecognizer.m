//
//  TPTapRecognizer.m
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPTapRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TPTapRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    [self.tapDelegate pressStartEventDetectedByTapRecognizer:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    [self.tapDelegate pressEndEventDetedByTapRecognizer:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    [self.tapDelegate pressCancelEventDetedByTapRecognizer:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    CGPoint tempLocation;

    for (UITouch* touch in touches) {
        tempLocation = [touch locationInView:self.view];

        if (tempLocation.x > CGRectGetWidth(self.view.frame) || tempLocation.y > CGRectGetHeight(self.view.frame)) {
            [self touchesCancelled:touches withEvent:event];

            break;
        }
    }
}

@end
