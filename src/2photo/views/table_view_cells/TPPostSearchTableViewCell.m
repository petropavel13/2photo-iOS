//
//  TPPostSearchTableViewCell.m
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPPostSearchTableViewCell.h"

@implementation TPPostSearchTableViewCell

- (void)setPost:(Post *)post {
    _post = post;

    self.textLabel.text = post.title;
}

@end
