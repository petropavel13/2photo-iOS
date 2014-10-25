//
//  UILabel+Extensions.h
//  2photo
//
//  Created by smolin_in on 26/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extensions)

@property (nonatomic, readonly) CGSize optimalSize;
@property (nonatomic, readonly) NSUInteger optimalNumberOfLines;

- (NSUInteger)optimalNumberOfLinesForWidth:(CGFloat)width;
- (CGSize)optimalSizeForWidth:(CGFloat)width;

@end
