//
//  TPCommentTableViewCell.h
//  2photo
//
//  Created by smolin_in on 27/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface TPCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) Comment* comment;

- (CGFloat)optimalHeightForWidth:(CGFloat)width;

@end
