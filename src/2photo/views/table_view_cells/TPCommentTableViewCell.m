//
//  TPCommentTableViewCell.m
//  2photo
//
//  Created by smolin_in on 27/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPCommentTableViewCell.h"
#import <SDWebImageManager.h>
#import "User.h"
#import "UILabel+Extensions.h"

@interface TPCommentTableViewCell () {
    id<SDWebImageOperation> currentOperation;
}

@property (strong, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *authorTimeSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeMessageSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarLeftSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageLeftSpaceConstraint;

@end

@implementation TPCommentTableViewCell

- (void)setCommentWithoutAvatar:(Comment *)comment {
    self.authorNameLabel.text = comment.author.name;
    self.timeLabel.text = [NSDateFormatter localizedStringFromDate:comment.date
                                                         dateStyle:NSDateFormatterLongStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    self.messageLabel.text = comment.message;
    self.ratingLabel.text = [comment.rating.stringValue stringByAppendingString:@"%"];
}

- (void)setComment:(Comment *)comment {
    [currentOperation cancel];
    _comment = comment;
    
    __weak typeof(self) weakSelf = self;
    
    NSURL* url = [NSURL URLWithString:[@"http://" stringByAppendingString:_comment.author.avatarUrl]];
    
    
    currentOperation = [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                    options:SDWebImageRetryFailed
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      if (finished) {
                                                          weakSelf.authorAvatarImageView.image = image;
                                                      }
                                                  }];
    [self setCommentWithoutAvatar:_comment];
}

- (CGFloat)optimalHeightForWidth:(CGFloat)width withComment:(Comment *)comment {
    [self setCommentWithoutAvatar:comment];
    
    CGRect r = self.frame;
    r.size.width = width;
    self.frame = r;
    
    [self layoutIfNeeded];
    
    return self.topSpaceConstraint.constant
    + self.authorNameLabel.optimalSize.height
    + self.timeMessageSpaceConstraint.constant
    + self.timeLabel.optimalSize.height
    + self.timeMessageSpaceConstraint.constant
    + self.messageLabel.optimalSize.height
    + self.bottomSpaceConstraint.constant;
}

- (void)setIndentationLevel:(NSInteger)indentationLevel {
    [super setIndentationLevel:indentationLevel];
    
    self.avatarLeftSpaceConstraint.constant = 16 * (indentationLevel + 1);
    self.messageLeftSpaceConstraint.constant = 16 * (indentationLevel + 1);
}

@end
