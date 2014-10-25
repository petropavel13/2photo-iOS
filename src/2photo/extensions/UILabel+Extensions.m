//
//  UILabel+Extensions.m
//  2photo
//
//  Created by smolin_in on 26/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "UILabel+Extensions.h"

@implementation UILabel (Extensions)

- (NSUInteger)optimalNumberOfLines {
    return [self optimalNumberOfLinesForWidth:CGRectGetWidth(self.frame)];
}

- (CGSize)optimalSizeForWidth:(CGFloat)width {
    const CGRect optimalRect = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName : self.font}
                                                 context:nil];
    return CGRectInset(optimalRect, -1, -1).size;
}

- (NSUInteger)optimalNumberOfLinesForWidth:(CGFloat)width {
    return [self optimalSizeForWidth:width].height / self.font.pointSize;
}

- (CGSize)optimalSize {
    return [self optimalSizeForWidth:CGRectGetWidth(self.frame)];
}

@end
