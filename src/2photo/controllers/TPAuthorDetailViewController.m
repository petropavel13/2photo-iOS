//
//  TPAuthorDetailViewController.m
//  2photo
//
//  Created by smolin_in on 09/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPAuthorDetailViewController.h"
#import <DZNSegmentedControl.h>
#import <SDWebImageManager.h>
#import "TPPostTableViewCell.h"
#import "TPCommentTableViewCell.h"
#import "TPInfiniteLoader.h"
#import "TPEntryDetailViewController.h"
#import "Entry.h"
#import "TPAppConstants.h"
#import "TPPostDetailTableViewController.h"
#import "UITextView+OptimalSize.h"
#import <UIScrollView+InfiniteScroll.h>

@interface TPAuthorDetailViewController () <TPInfiniteLoaderDelegate, TPPostDelegate> {
    BOOL postWasShown;
    TPInfiniteLoader* postsLoader;


    BOOL commentsWasShown;
    TPInfiniteLoader* commentsLoader;


    TPPostTableViewCell* sharedPostCell;
    TPCommentTableViewCell* sharedCommentCell;

    NSArray* posts;
    NSArray* comments;

    NSUInteger showFlag;
}

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) IBOutlet UILabel *carmaLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *postsLabel;

@property (strong, nonatomic) IBOutlet DZNSegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UITableView *postsTableView;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *postsCommentsLoading;

- (IBAction)selectedTabChanged:(DZNSegmentedControl *)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionTextViewHeightConstraint;

@end

@implementation TPAuthorDetailViewController

#define SHOW_POSTS 0
#define SHOW_COMMENTS 1

static NSString * const postCellIdentifier = @"post_cell";
static NSString * const commentCellIdentifier = @"comment_cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;

    NSURL* url = [NSURL URLWithString:_author.avatarUrl ];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                    options:SDWebImageRetryFailed
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      if (finished) {
                                                          weakSelf.avatarImageView.image = image;
                                                      }
                                                  }];

    self.nameLabel.text = _author.name;
    self.descriptionTextView.text = _author.userDescription;
    self.descriptionTextView.font = [UIFont systemFontOfSize:15];
    self.descriptionTextView.textColor = [UIColor lightGrayColor];

    const CGFloat optimalHeightForDescription = self.descriptionTextView.optimalSize.height;

    if (optimalHeightForDescription < self.descriptionTextViewHeightConstraint.constant) {
        self.descriptionTextViewHeightConstraint.constant = optimalHeightForDescription;
    }

    self.descriptionTextView.textContainerInset = UIEdgeInsetsZero;

    self.carmaLabel.text = _author.carma.stringValue;
    self.commentsLabel.text = _author.numberOfComments.stringValue;
    self.postsLabel.text = _author.numberOfPosts.stringValue;

    self.segmentedControl.font = [UIFont systemFontOfSize:20];
    self.segmentedControl.showsCount = NO;

    self.segmentedControl.items = @[@"Посты", @"Комментарии"];

    NSBundle* bundle = [NSBundle mainBundle];

    [self.postsTableView registerNib:[UINib nibWithNibName:@"TPPostTableViewCell_iPad" bundle:bundle] forCellReuseIdentifier:postCellIdentifier];
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"TPCommentTableViewCell" bundle:bundle] forCellReuseIdentifier:commentCellIdentifier];

    sharedPostCell = [[bundle loadNibNamed:@"TPPostTableViewCell_iPad" owner:self options:nil] firstObject];
    sharedCommentCell = [[bundle loadNibNamed:@"TPCommentTableViewCell" owner:self options:nil] firstObject];

    posts = @[];
    comments = @[];

    postWasShown = NO;
    postsLoader = [TPInfiniteLoader loaderWithClass:[Post class] filterParams:@{@"limit": @16, @"author": _author.id} andDelegate:self];

    commentsWasShown = NO;
    commentsLoader = [TPInfiniteLoader loaderWithClass:[Comment class] filterParams:@{@"limit": @32, @"author": _author.id} andDelegate:self];

    [postsLoader loadMore];

    showFlag = SHOW_POSTS;

    self.postsTableView.hidden = NO;
    self.commentsTableView.hidden = YES;
    
    self.postsTableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    __weak typeof(postsLoader) weakLoaderPosts = postsLoader;
    
    [self.postsTableView addInfiniteScrollWithHandler:^(UIScrollView *scrollView) {
        [weakLoaderPosts loadMore];
    }];
    
    self.commentsTableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    __weak typeof(commentsLoader) weakLoaderComments = commentsLoader;
    
    [self.commentsTableView addInfiniteScrollWithHandler:^(UIScrollView *scrollView) {
        [weakLoaderComments loadMore];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)selectedTabChanged:(DZNSegmentedControl *)sender {
    showFlag = sender.selectedSegmentIndex;

    if (showFlag == SHOW_POSTS) {
        commentsWasShown = YES;

        if (postWasShown == NO) {
            [self.postsCommentsLoading startAnimating];

            [postsLoader loadMore];
        }

        self.postsTableView.hidden = NO;
        self.commentsTableView.hidden = YES;
    } else if (showFlag == SHOW_COMMENTS) {
        postWasShown = YES;

        if (commentsWasShown == NO) {
            [self.postsCommentsLoading startAnimating];

            [commentsLoader loadMore];
        }

        self.postsTableView.hidden = YES;
        self.commentsTableView.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.postsTableView]) {
        return posts.count;
    } else if ([tableView isEqual:self.commentsTableView]) {
        return comments.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;

    if ([tableView isEqual:self.postsTableView]) {
        TPPostTableViewCell* targetCell = (TPPostTableViewCell*)(cell = [tableView dequeueReusableCellWithIdentifier:postCellIdentifier]);
        Post* temp = posts[indexPath.row];
        temp.author = _author;
        targetCell.post = temp;
        targetCell.delegate = self;
    } else if ([tableView isEqual:self.commentsTableView]) {
        TPCommentTableViewCell* targetCell = (TPCommentTableViewCell*)(cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier]);
        Comment* temp = comments[indexPath.row];
        temp.author = _author;
        targetCell.comment = temp;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.postsTableView]) {
        Post* temp = posts[indexPath.row];
        temp.author = _author;
        
        @synchronized(sharedPostCell) {
            return [sharedPostCell optimalHeightForWidth:CGRectGetWidth(tableView.frame) withPost:temp];
        }
    } else if ([tableView isEqual:self.commentsTableView]) {
        Comment* temp = comments[indexPath.row];
        temp.author = _author;
        
        @synchronized(sharedCommentCell) {
            return [sharedCommentCell optimalHeightForWidth:CGRectGetWidth(tableView.frame) withComment:temp];
        }
    }

    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TPPostTableViewCell* cell = (TPPostTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    TPPostDetailTableViewController* targetController = (TPPostDetailTableViewController*)[currentStoryboard instantiateViewControllerWithIdentifier:postDetailControllerIdentifier];
    targetController.post = cell.post;

    [self.navigationController pushViewController:targetController animated:YES];
}

- (void)infiniteLoader:(TPInfiniteLoader *)loader didFinishedLoading:(NSArray *)objects {
    NSMutableArray* mutableIndexes = [NSMutableArray arrayWithCapacity:objects.count];

    [self.postsCommentsLoading stopAnimating];
//    self.postsCommentsLoading.hidden = YES;

    if ([loader isEqual:postsLoader]) {
        for (NSUInteger i = posts.count; i < posts.count + objects.count; ++i) {
            [mutableIndexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }

        posts = [posts arrayByAddingObjectsFromArray:objects];

        [self.postsTableView insertRowsAtIndexPaths:mutableIndexes withRowAnimation:UITableViewRowAnimationFade];
        
        [self.postsTableView finishInfiniteScroll];
    } else if ([loader isEqual:commentsLoader]) {
        for (NSUInteger i = comments.count; i < comments.count + objects.count; ++i) {
            [mutableIndexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }

        comments = [comments arrayByAddingObjectsFromArray:objects];

        [self.commentsTableView insertRowsAtIndexPaths:mutableIndexes withRowAnimation:UITableViewRowAnimationFade];
        
        [self.commentsTableView finishInfiniteScroll];
    }
}

- (void)postTableViewCell:(TPPostTableViewCell *)cell didSelectEntry:(Entry *)entry {
    TPEntryDetailViewController* browser = [TPEntryDetailViewController new];
    browser.post = cell.post;
    browser.selectedEntry = [entry.order unsignedIntegerValue] - 1;

    [self.navigationController pushViewController:browser animated:YES];
}

@end
