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
    [currentOperation cancel];
    
    _entry = entry;
    
    [self.loadingIndicator startAnimating];
    self.entryImageView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    NSURL* url = [NSURL URLWithString:[@"http://" stringByAppendingString:_entry.mediumImageUrl]];
    
    currentOperation = [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                                       options:SDWebImageRetryFailed
                                                                      progress:nil
                                                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                         if (finished) {
                                                                             weakSelf.entryImageView.image = image;
                                                                             weakSelf.entryImageView.hidden = NO;
                                                                         } else {
                                                                         }
                                                                         
                                                                         [weakSelf.loadingIndicator stopAnimating];
                                                                     }];
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? darknessGray : nil;
}

@end
