//
//  TPPostsTableViewController.m
//  2photo
//
//  Created by smolin_in on 20/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPPostsTableViewController.h"
#import "AFHTTPRequestOperation+Extensions.h"
#import "TPAppConstants.h"
#import "TPPostTableViewCell.h"
#import "TPPostDetailTableViewController.h"
#import <SDImageCache.h>
#import "TPEntryDetailViewController.h"
#import "Entry.h"
#import "TPInfiniteLoader.h"
#import "TPListParser.h"
#import "TPTapRecognizer.h"
#import "TPSearchResultsTableViewController.h"
#import <WYPopoverController.h>
#import "Post.h"
#import "TPCategoriesTableViewController.h"
#import "TPRestMapping.h"
#import "TPObjectSelectedDelegate.h"
#import "TPAuthorDetailViewController.h"
#import "TPArtistDetailViewController.h"
#import "Artist+Parser.h"
#import "User+Parser.h"

@interface TPPostsTableViewController () <TPPostDelegate, TPInfiniteLoaderDelegate, TPTapDelegate,
                                            WYPopoverControllerDelegate, TPObjectSelectedDelegate> {
    NSArray* posts;
    TPPostTableViewCell* sharedCell;
    TPInfiniteLoader* loader;
    TPSearchResultsTableViewController* searchController;
    WYPopoverController* popoverControllerSearch;
                                                TPCategoriesTableViewController* categoriesController;
                                                WYPopoverController* popoverControllerCategories;

                                                PostCategory* selectedCategory;
}

@property (strong, nonatomic) IBOutlet UILabel *themeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *themeArrow;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)refreshRquested:(UIRefreshControl *)sender;

@end

@implementation TPPostsTableViewController

static NSString * const postCellIdentifier = @"post_cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"TPPostTableViewCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:postCellIdentifier];

    posts = [NSArray array];

    sharedCell = [[[NSBundle mainBundle] loadNibNamed:@"TPPostTableViewCell_iPad" owner:self options:nil] firstObject];

    loader = [TPInfiniteLoader loaderWithClass:[Post class] filterParams:@{@"limit": @(16)} andDelegate:self];

    [loader loadMore];

    searchController = [[TPSearchResultsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchController.preferredContentSize = CGSizeMake(384, 768);

    popoverControllerSearch = [[WYPopoverController alloc] initWithContentViewController:searchController];
    popoverControllerSearch.theme.fillTopColor = [UIColor darkGrayColor];
    popoverControllerSearch.theme.fillBottomColor = nil;
    popoverControllerSearch.theme.tintColor = nil;

    popoverControllerSearch.delegate = self;

    searchController.searchDelegate = self;
    NSString* url = [[apiUrl stringByAppendingString:[TPRestMapping resourceNameForClass:[PostCategory class]]] stringByAppendingString:@"/"];

    NSArray* categories = [TPListParser parseJSONObjects:[AFHTTPRequestOperation synchroniousRequestJSONFromUrl:url] ofType:[PostCategory class]];

    categoriesController = [[TPCategoriesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    categoriesController.preferredContentSize = CGSizeMake(240, 320);
    categoriesController.selectionDelegate = self;
    categoriesController.categories = categories;

    popoverControllerCategories = [[WYPopoverController alloc] initWithContentViewController:categoriesController];
    popoverControllerCategories.theme.fillTopColor = darknessGray;
    popoverControllerSearch.theme.fillBottomColor = [UIColor clearColor];

    selectedCategory = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (loader.isLoadingFinished == NO) {
        [self.tableView setContentOffset:CGPointMake(0, -CGRectGetHeight(self.refreshControl.frame)) animated:YES];
        [self.refreshControl beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] clearMemory];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return posts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPPostTableViewCell* cell = (TPPostTableViewCell*)[tableView dequeueReusableCellWithIdentifier:postCellIdentifier];

    cell.post = posts[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post* post = posts[indexPath.row];

    @synchronized(sharedCell) {
        sharedCell.post = post;
        return [sharedCell optimalHeightForWidth:CGRectGetWidth(tableView.frame)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TPPostTableViewCell* cell = (TPPostTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    TPPostDetailTableViewController* targetController = (TPPostDetailTableViewController*)[currentStoryboard instantiateViewControllerWithIdentifier:postDetailControllerIdentifier];
    targetController.post = cell.post;

    [self.navigationController pushViewController:targetController animated:YES];
}

- (void)postTableViewCell:(TPPostTableViewCell *)cell didSelectEntry:(Entry *)entry {
    TPEntryDetailViewController* browser = [TPEntryDetailViewController new];
    browser.post = cell.post;
    browser.selectedEntry = [entry.order unsignedIntegerValue] - 1;

    [self.navigationController pushViewController:browser animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > (scrollView.contentSize.height * 0.8)) {
        [loader loadMore];
    }
}

//

- (void)infiniteLoader:(TPInfiniteLoader *)loader didFinishedLoading:(NSArray *)objects {
    NSMutableArray* mutableIndexes = [NSMutableArray arrayWithCapacity:objects.count];

    for (NSUInteger i = posts.count; i < posts.count + objects.count; ++i) {
        [mutableIndexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    posts = [posts arrayByAddingObjectsFromArray:objects];

    [self.refreshControl endRefreshing];

    [self.tableView insertRowsAtIndexPaths:mutableIndexes withRowAnimation:UITableViewRowAnimationNone];
}

- (void)pressStartEventDetectedByTapRecognizer:(TPTapRecognizer *)recognizer {
    [UIView animateWithDuration:0.1 animations:^{
        self.themeLabel.alpha = 0.5;
        self.themeArrow.alpha = 0.1;
    }];
}

- (void)pressEndEventDetedByTapRecognizer:(TPTapRecognizer *)recognizer {
    [UIView animateWithDuration:0.1 animations:^{
        self.themeLabel.alpha = 1.0;
        self.themeArrow.alpha = 0.6;
    }];

    [popoverControllerCategories presentPopoverFromRect:self.themeLabel.bounds
                                                 inView:self.themeLabel
                               permittedArrowDirections:WYPopoverArrowDirectionAny
                                               animated:YES];
}

- (void)pressCancelEventDetedByTapRecognizer:(TPTapRecognizer *)recognizer {
    [UIView animateWithDuration:0.1 animations:^{
        self.themeLabel.alpha = 1.0;
        self.themeArrow.alpha = 0.6;
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popoverControllerSearch presentPopoverFromRect:self.searchBar.bounds
                                                 inView:self.searchBar
                               permittedArrowDirections:WYPopoverArrowDirectionAny
                                               animated:YES];
    });
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchController searchBar:searchBar textDidChange:searchText];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    [popoverController dismissPopoverAnimated:YES];
//    [searchController searchBarTextDidEndEditing:searchBar];
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController {
    [self.searchBar resignFirstResponder];
}


- (void)objectSelected:(id)object inController:(id)controller {
    if ([controller isEqual:searchController]) {
        if ([object isKindOfClass:[User class]]) {
            TPAuthorDetailViewController* authorController = [currentStoryboard instantiateViewControllerWithIdentifier:authorDetailControllerIdentifier];
            User* obj = object;
            NSString* url = [[apiUrl stringByAppendingString:[TPRestMapping resourceNameForClass:[User class]]] stringByAppendingString:[NSString stringWithFormat:@"/%@/", obj.id]];
            authorController.author = [User detailObjectFromJSON:[AFHTTPRequestOperation synchroniousRequestJSONFromUrl:url]];

            [popoverControllerSearch dismissPopoverAnimated:YES completion:^{
                [self.navigationController pushViewController:authorController animated:YES];
            }];
        } else if ([object isKindOfClass:[Artist class]]) {
            TPArtistDetailViewController* artistController = [currentStoryboard instantiateViewControllerWithIdentifier:artistDetailControllerIdentifier];

            Artist* obj = object;
            NSString* url = [[apiUrl stringByAppendingString:[TPRestMapping resourceNameForClass:[Artist class]]] stringByAppendingString:[NSString stringWithFormat:@"/%@/", obj.id]];
            artistController.artist = [Artist detailObjectFromJSON:[AFHTTPRequestOperation synchroniousRequestJSONFromUrl:url]];

            [popoverControllerSearch dismissPopoverAnimated:YES completion:^{
                [self.navigationController pushViewController:artistController animated:YES];
            }];
        } else if ([object isKindOfClass:[Post class]]) {
            TPPostDetailTableViewController* targetController = [currentStoryboard instantiateViewControllerWithIdentifier:postDetailControllerIdentifier];
            targetController.post = object;

            [popoverControllerSearch dismissPopoverAnimated:YES completion:^{
                [self.navigationController pushViewController:targetController animated:YES];
            }];
        }
    } else if ([controller isEqual:categoriesController]) {
        selectedCategory = object;

        if (selectedCategory == nil) {
            loader = [TPInfiniteLoader loaderWithClass:[Post class] filterParams:@{@"limit": @(16)} andDelegate:self];
            self.themeLabel.text = @"Последние";
        } else {
            loader = [TPInfiniteLoader loaderWithClass:[Post class] filterParams:@{@"limit": @(16), @"categories": selectedCategory.id} andDelegate:self];
            self.themeLabel.text = [NSString stringWithFormat:@"Последние (%@)", selectedCategory.title];
        }

        posts = @[];
        [self.tableView reloadData];

        [loader loadMore];

        [popoverControllerCategories dismissPopoverAnimated:YES];
    }
}

- (IBAction)refreshRquested:(UIRefreshControl *)sender {
    if (selectedCategory == nil) {
        loader = [TPInfiniteLoader loaderWithClass:[Post class] filterParams:@{@"limit": @(16)} andDelegate:self];
    } else {
        loader = [TPInfiniteLoader loaderWithClass:[Post class] filterParams:@{@"limit": @(16), @"categories": selectedCategory.id} andDelegate:self];
    }

    posts = @[];

    [self.tableView reloadData];

    [loader loadMore];
}

@end
