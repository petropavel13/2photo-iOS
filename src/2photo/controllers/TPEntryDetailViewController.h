//
//  TPEntryDetailViewController.h
//  2photo
//
//  Created by smolin_in on 27/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <MWPhotoBrowser.h>

@interface TPEntryDetailViewController : MWPhotoBrowser

@property (nonatomic, strong) Post* post;
@property (nonatomic) NSUInteger selectedEntry;

@end
