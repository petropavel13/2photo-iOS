//
//  TPPostTableViewCell.m
//  2photo
//
//  Created by smolin_in on 20/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPPostTableViewCell.h"
#import "TPEntryCollectionViewCell.h"
#import "User.h"
#import "Tag.h"
#import "UILabel+Extensions.h"
#import "TPAppConstants.h"

@interface TPPostTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray* sortedEntries;
}

@property (strong, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postTagsLabel;

@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;

@property (strong, nonatomic) IBOutlet UICollectionView *entriesCollectionView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleAuthorSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *authorTagsSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

@end

@implementation TPPostTableViewCell

static NSString * const entryCollectionCellIdentifier = @"entry_cell";

@synthesize post=_post;

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.entriesCollectionView registerNib:[UINib nibWithNibName:@"TPEntryCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:entryCollectionCellIdentifier];

    UIView* bg = [UIView new];
    bg.backgroundColor = darknessGray;

    self.selectedBackgroundView = bg;
}

- (void)setPostWithoutEntries:(Post *)post {
    self.postTitleLabel.text = post.title;
    self.authorNameLabel.text = [@"Автор: " stringByAppendingString:post.author.name];
    
    NSMutableArray* mutableTagsNames = [NSMutableArray arrayWithCapacity:post.tags.count];
    
    for (Tag* t in post.tags) {
        [mutableTagsNames addObject:t.title];
    }
    
    self.postTagsLabel.text = [@"Метки: " stringByAppendingString:[mutableTagsNames componentsJoinedByString:@" "]];
    self.ratingLabel.text = [post.rating.stringValue stringByAppendingString:@"%"];
    self.commentsLabel.text = post.numberOfComments.stringValue;
}

- (void)setPost:(Post *)post {
    _post = post;

    [self setPostWithoutEntries:_post];
    
    sortedEntries = [_post.entries sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];

    self.entriesCollectionView.contentOffset = CGPointMake(0, 0);
    
    [self.entriesCollectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPEntryCollectionViewCell* cell = (TPEntryCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:entryCollectionCellIdentifier forIndexPath:indexPath];
    cell.entry = sortedEntries[indexPath.row];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return sortedEntries.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate postTableViewCell:self didSelectEntry:sortedEntries[indexPath.row]];
}

- (CGFloat)optimalHeightForWidth:(CGFloat)width withPost:(Post *)post{
    [self setPostWithoutEntries:post];
    
    CGRect r = self.frame;
    r.size.width = width;
    self.frame = r;
    [self layoutIfNeeded];

    return self.topSpaceConstraint.constant
    + self.postTitleLabel.optimalSize.height
    + self.titleAuthorSpaceConstraint.constant
    + self.authorNameLabel.optimalSize.height
    + self.authorTagsSpaceConstraint.constant
    + self.postTagsLabel.optimalSize.height
    + CGRectGetHeight(self.entriesCollectionView.frame)
    + self.bottomSpaceConstraint.constant;
}

@end
