//
//  TPArtistsTableViewController.m
//  2photo
//
//  Created by smolin_in on 11/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPArtistsTableViewController.h"
#import "TPArtistDetailTableViewCell.h"
#import "TPInfiniteLoader.h"
#import "Artist.h"
#import <SDImageCache.h>
#import "TPArtistDetailViewController.h"
#import "TPAppConstants.h"
#import <WYPopoverController.h>
#import "TPSortTypeTableViewController.h"
#import "TPTapRecognizer.h"
#import <UIScrollView+InfiniteScroll.h>

@interface TPArtistsTableViewController () <TPInfiniteLoaderDelegate, TPObjectSelectedDelegate> {
    TPInfiniteLoader* infiniteLoader;
    NSArray* artists;

    NSString* orderType;
    NSString* searchQuery;

    WYPopoverController* popoverSort;
}

@property (strong, nonatomic) IBOutlet UILabel *sortLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sortArrow;

- (void)updateLoader;

@end

@implementation TPArtistsTableViewController

static NSString * const artistCellIdentifier = @"artist_cell";

static NSDictionary* sortTypeNameMapping;

+ (void)initialize {
    [super initialize];

    sortTypeNameMapping = @{@"name": @"Имя",
                            @"-number_of_posts": @"Количество постов"};
}

- (void)viewDidLoad {
    [super viewDidLoad];

    artists = @[];

    [self.tableView registerNib:[UINib nibWithNibName:@"TPArtistDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:artistCellIdentifier];

    TPSortTypeTableViewController* sortController = [[TPSortTypeTableViewController alloc] initWithStyle:UITableViewStylePlain];
    sortController.selectionDelegate = self;
    sortController.typeNameMapping = sortTypeNameMapping;
    sortController.selectedType = orderType = @"-number_of_posts";

    popoverSort = [[WYPopoverController alloc] initWithContentViewController:sortController];

    [self updateLoader];
    [infiniteLoader loadMore];
    
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    __weak typeof(infiniteLoader) weakLoader = infiniteLoader;
    
    [self.tableView addInfiniteScrollWithHandler:^(UIScrollView *scrollView) {
        [weakLoader loadMore];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (infiniteLoader.isLoadingFinished == NO) {
        [self.tableView setContentOffset:CGPointMake(0, -CGRectGetHeight(self.refreshControl.frame)) animated:YES];
        [self.refreshControl beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] clearMemory];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPArtistDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:artistCellIdentifier forIndexPath:indexPath];
    cell.artist = artists[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TPArtistDetailViewController* targetController = [currentStoryboard instantiateViewControllerWithIdentifier:artistDetailControllerIdentifier];
    targetController.artist = artists[indexPath.row];

    [self.navigationController pushViewController:targetController animated:YES];
}

- (void)infiniteLoader:(TPInfiniteLoader *)loader didFinishedLoading:(NSArray *)objects {
    if ([infiniteLoader isEqual:loader] == NO) return;

    NSMutableArray* mutableIndexes = [NSMutableArray arrayWithCapacity:objects.count];

    for (NSUInteger i = artists.count; i < artists.count + objects.count; ++i) {
        [mutableIndexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    artists = [artists arrayByAddingObjectsFromArray:objects];

    [self.refreshControl endRefreshing];
    [self.refreshControl removeFromSuperview];

    [self.tableView insertRowsAtIndexPaths:mutableIndexes withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView finishInfiniteScroll];
}

- (void)objectSelected:(id)object inController:(id)controller {
    orderType = object;

    artists = @[];
    [self.tableView reloadData];
    
    [self.tableView addSubview:self.refreshControl];
    
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, -CGRectGetHeight(self.refreshControl.frame) * 2) animated:YES];

    [self updateLoader];

    [infiniteLoader loadMore];

    [popoverSort dismissPopoverAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText != nil && searchText.length > 0) {
        searchQuery = searchText;
    } else {
        searchQuery = nil;
    }

    artists = @[];
    [self.tableView reloadData];

    [self updateLoader];
    [infiniteLoader loadMore];
}

- (void)updateLoader {
    if (searchQuery != nil && searchQuery.length > 0) {
        if (orderType != nil) {
            infiniteLoader = [TPInfiniteLoader loaderWithClass:[Artist class] filterParams:@{@"limit": @32, @"ordering": orderType, @"search": searchQuery,} andDelegate:self];
            self.sortLabel.text = [NSString stringWithFormat:@"Сортировка (%@)", sortTypeNameMapping[orderType]];
        } else {
            infiniteLoader = [TPInfiniteLoader loaderWithClass:[Artist class] filterParams:@{@"limit": @32, @"search": searchQuery,} andDelegate:self];
        }
    } else if (orderType != nil) {
        infiniteLoader = [TPInfiniteLoader loaderWithClass:[Artist class] filterParams:@{@"limit": @32, @"ordering": orderType,} andDelegate:self];
        self.sortLabel.text = [NSString stringWithFormat:@"Сортировка (%@)", sortTypeNameMapping[orderType]];
    } else {
        infiniteLoader = [TPInfiniteLoader loaderWithClass:[Artist class] filterParams:@{@"limit": @32} andDelegate:self];
    }
}

- (void)pressStartEventDetectedByTapRecognizer:(TPTapRecognizer *)recognizer {
    [UIView animateWithDuration:0.1 animations:^{
        self.sortLabel.alpha = 0.5;
        self.sortArrow.alpha = 0.1;
    }];
}

- (void)pressEndEventDetedByTapRecognizer:(TPTapRecognizer *)recognizer {
    [UIView animateWithDuration:0.1 animations:^{
        self.sortLabel.alpha = 1.0;
        self.sortArrow.alpha = 0.6;
    }];

    [popoverSort presentPopoverFromRect:self.sortLabel.bounds
                                 inView:self.sortLabel
               permittedArrowDirections:WYPopoverArrowDirectionAny
                               animated:YES];
}

- (void)pressCancelEventDetedByTapRecognizer:(TPTapRecognizer *)recognizer {
    [UIView animateWithDuration:0.1 animations:^{
        self.sortLabel.alpha = 1.0;
        self.sortArrow.alpha = 0.6;
    }];
}

@end
