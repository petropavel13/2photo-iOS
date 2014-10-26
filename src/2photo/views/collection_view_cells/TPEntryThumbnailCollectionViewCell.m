//
//  TPEntryThumbnailCollectionViewCell.m
//  2photo
//
//  Created by smolin_in on 26/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPEntryThumbnailCollectionViewCell.h"
#import <SDWebImageManager.h>
#import "TPAppConstants.h"

@interface TPEntryThumbnailCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UILabel *orderLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation TPEntryThumbnailCollectionViewCell

@synthesize entry=_entry;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.layer.masksToBounds = NO;
}

- (void)setEntry:(Entry *)entry {
    _entry = entry;
    
    [self.loadingIndicator startAnimating];
    self.thumbnailImageView.hidden = YES;
    
    NSURL* url = [NSURL URLWithString:[@"http://" stringByAppendingString:_entry.bigImageUrl]];
    
    __weak typeof(self) weakSelf = self;
    
    __block Entry* blockEntry = _entry;
    
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                    options:SDWebImageRetryFailed
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      if (finished) {
                                                          if ([blockEntry isEqual:_entry]) { // check if cell already reused
                                                              weakSelf.thumbnailImageView.image = image;
                                                              weakSelf.thumbnailImageView.hidden = NO;
                                                              [weakSelf.loadingIndicator stopAnimating];
                                                          }
                                                      } else {
                                                          [weakSelf.loadingIndicator stopAnimating];
                                                      }
                                                  }];
    
    self.orderLabel.text = [@"#" stringByAppendingString:_entry.order.stringValue];
    self.ratingLabel.text = [_entry.rating.stringValue stringByAppendingString:@"%"];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? darknessGray : nil;
}

@end
