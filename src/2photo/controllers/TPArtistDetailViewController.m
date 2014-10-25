//
//  TPArtistDetailViewController.m
//  2photo
//
//  Created by smolin_in on 11/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPArtistDetailViewController.h"
#import <DZNSegmentedControl.h>
#import <SDImageCache.h>
#import "TPInfiniteLoader.h"
#import "TPPostTableViewCell.h"
#import "TPPostDetailTableViewController.h"
#import "TPAppConstants.h"
#import "TPEntryDetailViewController.h"
#import "Entry.h"
#import <SDWebImageManager.h>
#import "UITextView+OptimalSize.h"

@interface TPArtistDetailViewController () <TPInfiniteLoaderDelegate, TPPostDelegate> {
    TPInfiniteLoader* infiniteLoader;

    NSArray* posts;

    TPPostTableViewCell* sharedPostCell;
}

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet DZNSegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UITableView *postsTableView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *postsLoading;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionTextViewHeightConstraint;

@end

@implementation TPArtistDetailViewController

static NSString * const postCellIdentifier = @"post_cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;

    NSURL* url = [NSURL URLWithString:[@"http://" stringByAppendingString:_artist.avatarUrl] ];

    [[SDWebImageManager sharedManager] downloadWithURL:url
                                               options:SDWebImageRetryFailed
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished) {
                                                     weakSelf.avatarImageView.image = image;
                                                 }
                                             }];

    self.nameLabel.text = _artist.name;
    self.descriptionTextView.text = _artist.artistDescription;
    self.descriptionTextView.font = [UIFont systemFontOfSize:15];
    self.descriptionTextView.textColor = [UIColor lightGrayColor];

    const CGFloat optimalHeightForDescription = self.descriptionTextView.optimalSize.height;

    if (optimalHeightForDescription < self.descriptionTextViewHeightConstraint.constant) {
        self.descriptionTextViewHeightConstraint.constant = optimalHeightForDescription;
    }

    self.descriptionTextView.textContainerInset = UIEdgeInsetsZero;	

    self.segmentedControl.font = [UIFont systemFontOfSize:20];
    self.segmentedControl.showsCount = NO;

    self.segmentedControl.items = @[@"Посты"];

    NSBundle* bundle = [NSBundle mainBundle];

    [self.postsTableView registerNib:[UINib nibWithNibName:@"TPPostTableViewCell_iPad" bundle:bundle] forCellReuseIdentifier:postCellIdentifier];

    sharedPostCell = [[bundle loadNibNamed:@"TPPostTableViewCell_iPad" owner:self options:nil] firstObject];

    posts = @[];

    infiniteLoader = [TPInfiniteLoader loaderWithClass:[Post class] filterParams:@{@"limit": @16, @"artists": _artist.id} andDelegate:self];

    [infiniteLoader loadMore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] clearMemory];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:postCellIdentifier];
    cell.post = posts[indexPath.row];
    cell.delegate = self;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TPPostTableViewCell* cell = (TPPostTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    TPPostDetailTableViewController* targetController = (TPPostDetailTableViewController*)[currentStoryboard instantiateViewControllerWithIdentifier:postDetailControllerIdentifier];
    targetController.post = cell.post;

    [self.navigationController pushViewController:targetController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.postsTableView]) {
        @synchronized(sharedPostCell) {
            sharedPostCell.post = posts[indexPath.row];
            return [sharedPostCell optimalHeightForWidth:CGRectGetWidth(tableView.frame)];;
        }
    }

    return UITableViewAutomaticDimension;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > (scrollView.contentSize.height * 0.8)) {
        [infiniteLoader loadMore];
    }
}

- (void)infiniteLoader:(TPInfiniteLoader *)loader didFinishedLoading:(NSArray *)objects {
    NSMutableArray* mutableIndexes = [NSMutableArray arrayWithCapacity:objects.count];

    [self.postsLoading stopAnimating];

    for (NSUInteger i = posts.count; i < posts.count + objects.count; ++i) {
        [mutableIndexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    posts = [posts arrayByAddingObjectsFromArray:objects];

    [self.postsTableView insertRowsAtIndexPaths:mutableIndexes withRowAnimation:UITableViewRowAnimationFade];
}

- (void)postTableViewCell:(TPPostTableViewCell *)cell didSelectEntry:(Entry *)entry {
    TPEntryDetailViewController* browser = [TPEntryDetailViewController new];
    browser.post = cell.post;
    browser.selectedEntry = [entry.order unsignedIntegerValue] - 1;

    [self.navigationController pushViewController:browser animated:YES];
}

@end
