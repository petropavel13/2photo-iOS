//
//  TPEntryDetailViewController.m
//  2photo
//
//  Created by smolin_in on 27/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPEntryDetailViewController.h"
#import "Entry.h"

@interface TPEntryDetailViewController () <MWPhotoBrowserDelegate> {
    NSArray* sortedEntries;
}

@end

@implementation TPEntryDetailViewController

- (void)viewDidLoad {
    sortedEntries = [_post.entries sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    self.delegate = self;
    self.displayActionButton = NO;
    self.hideControlsWhenDragging = NO;

    [super viewDidLoad];

    [self setCurrentPhotoIndex:_selectedEntry];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return sortedEntries.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    Entry* entry = sortedEntries[index];
    NSString* url = [@"http://" stringByAppendingString:entry.bigImageUrl];
    MWPhoto* photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
    photo.caption = entry.entryDescription.length > 0 ? entry.entryDescription : nil;

    return photo;
}

@end
