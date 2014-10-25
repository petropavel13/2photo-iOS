//
//  TPAuthorSearchTableViewCell.m
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPAuthorTableViewCell.h"
#import <SDWebImageManager.h>

@interface TPAuthorTableViewCell () {
    id<SDWebImageOperation> operation;
}

@property (strong, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *authorNameLabel;

@end

@implementation TPAuthorTableViewCell

- (void)setAuthor:(User *)author {
    _author = author;
    
    NSURL* url = [NSURL URLWithString:[@"http://" stringByAppendingString:_author.avatarUrl]];
    
    __weak typeof(self) weakSelf = self;
    
    operation = [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                                options:SDWebImageRetryFailed
                                                               progress:nil
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                  if (finished) {
                                                                      if (finished) {
                                                                          weakSelf.authorAvatarImageView.image = image;
                                                                      }
                                                                  }
                                                              }];
    self.authorNameLabel.text = _author.name;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [operation cancel];
    
    self.authorAvatarImageView.image = nil;
}

@end
