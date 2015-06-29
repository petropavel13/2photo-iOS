//
//  TPAuthorDetailTableViewCell.m
//  2photo
//
//  Created by smolin_in on 03/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPAuthorDetailTableViewCell.h"
#import <SDWebImageManager.h>
#import "TPAppConstants.h"

@interface TPAuthorDetailTableViewCell () {
    id<SDWebImageOperation> operation;
}

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *carmaLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *postsLabel;

@end

@implementation TPAuthorDetailTableViewCell

- (void)setAuthor:(User *)author {
    _author = author;
    
    NSURL* url = [NSURL URLWithString:_author.avatarUrl];

    __weak typeof(self) weakSelf = self;
    
    operation = [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                                 options:SDWebImageRetryFailed
                                                                progress:nil
                                                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                   if (finished) {
                                                                       weakSelf.avatarImageView.image = image;
                                                                   }
                                                               }];

    self.nameLabel.text = _author.name;
    self.carmaLabel.text = _author.carma.stringValue;
    self.commentsLabel.text = _author.numberOfComments.stringValue;
    self.postsLabel.text = _author.numberOfPosts.stringValue;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [operation cancel];

    self.avatarImageView.image = nil;
}

@end
