//
//  TPArtistDetailTableViewCell.m
//  2photo
//
//  Created by smolin_in on 10/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPArtistDetailTableViewCell.h"
#import <SDWebImageManager.h>

@interface TPArtistDetailTableViewCell () {
    id<SDWebImageOperation> operation;
}

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postsLabel;

@end

@implementation TPArtistDetailTableViewCell

- (void)setArtist:(Artist *)artist {
    _artist = artist;

    __weak typeof(self) weakSelf = self;

    NSURL* url = [NSURL URLWithString:[@"http://" stringByAppendingString:_artist.avatarUrl]];

    operation = [[SDWebImageManager sharedManager] downloadWithURL:url
                                                           options:SDWebImageRetryFailed
                                                          progress:nil
                                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                             if (finished) {
                                                                 weakSelf.avatarImageView.image = image;
                                                             }
                                                         }];

    self.nameLabel.text = _artist.name;
    self.postsLabel.text = _artist.numberOfPosts.stringValue;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.avatarImageView.image = nil;

    [operation cancel];
}

@end
