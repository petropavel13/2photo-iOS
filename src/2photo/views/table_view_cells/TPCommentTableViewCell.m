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

@interface TPCommentTableViewCell ()

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

- (void)setComment:(Comment *)comment {
    _comment = comment;

    __weak typeof(self) weakSelf = self;

    __block Comment* blockComment = _comment;

    NSURL* url = [NSURL URLWithString:[@"http://" stringByAppendingString:_comment.author.avatarUrl]];

    [[SDWebImageManager sharedManager] downloadWithURL:url
                                               options:SDWebImageRetryFailed
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished) {
                                                     if ([blockComment isEqual:_comment]) {
                                                         weakSelf.authorAvatarImageView.image = image;
                                                     }
                                                 } else {
                                                     //
                                                 }
                                             }];

    self.authorNameLabel.text = _comment.author.name;
    self.timeLabel.text = [NSDateFormatter localizedStringFromDate:_comment.date
                                                         dateStyle:NSDateFormatterLongStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    self.messageLabel.text = _comment.message;
    self.ratingLabel.text = [_comment.rating.stringValue stringByAppendingString:@"%"];
}

- (CGFloat)optimalHeightForWidth:(CGFloat)width {
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
