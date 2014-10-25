//
//  TPTapRecognizer.h
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPTapRecognizer;

@protocol TPTapDelegate <NSObject>

- (void)pressStartEventDetectedByTapRecognizer:(TPTapRecognizer*)recognizer;
- (void)pressEndEventDetedByTapRecognizer:(TPTapRecognizer*)recognizer;
- (void)pressCancelEventDetedByTapRecognizer:(TPTapRecognizer*)recognizer;

@end

@interface TPTapRecognizer : UITapGestureRecognizer

@property (nonatomic, weak) IBOutlet id<TPTapDelegate> tapDelegate;

@end
