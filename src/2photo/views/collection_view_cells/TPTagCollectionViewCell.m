//
//  TPTagCollectionViewCell.m
//  2photo
//
//  Created by smolin_in on 26/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPTagCollectionViewCell.h"
#import "UILabel+Extensions.h"

@interface TPTagCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TPTagCollectionViewCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.masksToBounds = NO;
}

- (void)setPostCategory:(PostCategory *)postCategory {
    _postCategory = postCategory;

    self.titleLabel.text = _postCategory.title;
}

- (void)setPostTag:(Tag *)postTag {
    _postTag = postTag;

    self.titleLabel.text = _postTag.title;
}

- (CGSize)optimalSize {
    CGSize s = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.frame))
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName : self.titleLabel.font}
                                                        context:nil].size;
    s.width += 2 * 8 + 1;
    s.height *= 1.5;
    return s;
}


@end
