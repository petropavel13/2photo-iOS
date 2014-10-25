//
//  TPArtistSearchTableViewCell.m
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPArtistTableViewCell.h"
#import <SDWebImageManager.h>

@interface TPArtistTableViewCell () {
    id<SDWebImageOperation> opearation;
}

@property (strong, nonatomic) IBOutlet UIImageView *artistAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *artistsNameLabel;

@end

@implementation TPArtistTableViewCell

- (void)setArtist:(Artist *)artist {
    _artist = artist;

    if (_artist.avatarUrl) {
        __weak typeof(self) weakSelf = self;

        NSURL* url = [NSURL URLWithString:[@"http://" stringByAppendingString:_artist.avatarUrl]];

        opearation = [[SDWebImageManager sharedManager] downloadWithURL:url
                                                                options:SDWebImageHighPriority | SDWebImageRetryFailed
                                                               progress:nil
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                                  if (finished) {
                                                                      weakSelf.artistAvatarImageView.image = image;
                                                                  }
                                                              }];
    }


    self.artistsNameLabel.text = _artist.name;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [opearation cancel];

    self.artistAvatarImageView.image = nil;
}

@end
