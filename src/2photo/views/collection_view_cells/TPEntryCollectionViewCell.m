//
//  TPEntryListCollectionViewCell.m
//  2photo
//
//  Created by smolin_in on 20/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPEntryCollectionViewCell.h"
#import <SDWebImageManager.h>
#import "TPAppConstants.h"

@interface TPEntryCollectionViewCell () {
    id<SDWebImageOperation> currentOperation;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *entryImageView;


@end

@implementation TPEntryCollectionViewCell

@synthesize entry=_entry;

- (void)awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.layer.masksToBounds = NO;
}

- (void)setEntry:(Entry *)entry {
    _entry = entry;

    [self.loadingIndicator startAnimating];
    self.entryImageView.hidden = YES;

    __weak typeof(self) weakSelf = self;

    NSURL* url = [NSURL URLWithString:[@"http://" stringByAppendingString:_entry.mediumImageUrl]];

//    __block Entry* blockEntry = _entry;

    currentOperation = [[SDWebImageManager sharedManager] downloadWithURL:url
                                                                  options:SDWebImageRetryFailed | SDWebImageContinueInBackground
                                                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                     //
                                                                 }
                                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                                    if (finished) {
//                                                                        if ([blockEntry isEqual:_entry]) { // check if cell already reused
                                                                            weakSelf.entryImageView.image = image;
                                                                            weakSelf.entryImageView.hidden = NO;
                                                                            [weakSelf.loadingIndicator stopAnimating];
//                                                                        }
                                                                    } else {
                                                                        [weakSelf.loadingIndicator stopAnimating];
                                                                    }
                                                                }];
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? darknessGray : nil;
}

- (void)prepareForReuse {
    [currentOperation cancel];
}

@end
