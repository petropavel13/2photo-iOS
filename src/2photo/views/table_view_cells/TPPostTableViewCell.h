//
//  TPPostTableViewCell.h
//  2photo
//
//  Created by smolin_in on 20/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@class TPPostTableViewCell;

@protocol TPPostDelegate <NSObject>

- (void)postTableViewCell:(TPPostTableViewCell*)cell didSelectEntry:(Entry*)entry;

@end

@interface TPPostTableViewCell : UITableViewCell

@property (nonatomic, strong) Post* post;
@property (nonatomic, weak) id<TPPostDelegate> delegate;

- (CGFloat)optimalHeightForWidth:(CGFloat)width withPost:(Post*)post;

@end
