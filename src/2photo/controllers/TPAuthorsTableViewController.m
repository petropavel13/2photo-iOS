//
//  TPAuthorsTableViewController.m
//  2photo
//
//  Created by smolin_in on 03/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPAuthorsTableViewController.h"
#import "TPAuthorDetailTableViewCell.h"
#import "TPInfiniteLoader.h"
#import "User.h"
#import "TPObjectSelectedDelegate.h"
#import <WYPopoverController.h>
#import "TPSortTypeTableViewController.h"
#import "TPAppConstants.h"
#import "TPAuthorDetailViewController.h"


@interface TPAuthorsTableViewController () <TPInfiniteLoaderDelegate, TPObjectSelectedDelegate> {
    NSArray* authors;
    TPInfiniteLoader* infiniteLoader;
    NSString* searchQuery;
    NSString* orderType;

    WYPopoverController* popoverSort;
}

- (void)updateLoader;

@property (strong, nonatomic) IBOutlet UILabel *sortLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sortArrow;

@end

@implementation TPAuthorsTableViewController

static NSString * const authorCellCellIdentifier = @"authorCell";

static NSDictionary* sortTypeNameMapping;

+ (void)initialize {
    [super initialize];

    sortTypeNameMapping = @{@"name": @"Имя",
                            @"-carma": @"Карма",
                            @"-last_visit": @"Последнее посещение",
                            @"-number_of_comments": @"Кол-во комментариев",
                            @"-number_of_posts": @"Количество постов"};
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"TPAuthorDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:authorCellCellIdentifier];

    authors = @[];

    TPSortTypeTableViewController* sortController = [[TPSortTypeTableViewController alloc] initWithStyle:UITableViewStylePlain];
    sortController.selectionDelegate = self;
    sortController.typeNameMapping = sortTypeNameMapping;
    sortController.selectedType = orderType = @"-number_of_posts";

    popoverSort = [[WYPopoverController alloc] initWithContentViewController:sortController];

    [self updateLoader];
    [infiniteLoader loadMore];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (infiniteLoader.isLoadingFinished == NO) {
        [self.tableView setContentOffset:CGPointMake(0, -CGRectGetHeight(self.refreshControl.frame)) animated:YES];
        [self.refreshControl beginRefreshing];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return authors.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPAuthorDetailTableViewCell *cell = (TPAuthorDetailTableViewCell*) [tableView dequeueReusableCellWithIdentifier:authorCellCellIdentifier forIndexPath:indexPath];
    cell.author = authors[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TPAuthorDetailViewController* authorController = [currentStoryboard instantiateViewControllerWithIdentifier:authorDetailControllerIdentifier];
    authorController.author = authors[indexPath.row];

    [self.navigationController pushViewController:authorController animated:YES];
}

- (void)infiniteLoader:(TPInfiniteLoader *)loader didFinishedLoading:(NSArray *)objects {
    if ([infiniteLoader isEqual:loader] == NO) return;

    NSMutableArray* mutableIndexes = [NSMutableArray arrayWithCapacity:objects.count];

    for (NSUInteger i = authors.count; i < authors.count + objects.count; ++i) {
        [mutableIndexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    authors = [authors arrayByAddingObjectsFromArray:objects];

    [self.refreshControl endRefreshing];
    self.refreshControl = nil;

    [self.tableView insertRowsAtIndexPaths:mutableIndexes withRowAnimation:UITableViewRowAnimationNone];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText != nil && searchText.length > 0) {
        searchQuery = searchText;
    } else {
        searchQuery = nil;
    }

    authors = @[];
    [self.tableView reloadData];

    [self updateLoader];
    [infiniteLoader loadMore];
}

- (void)objectSelected:(id)object inController:(id)controller {
    orderType = object;

    authors = @[];
    [self.tableView reloadData];

    [self updateLoader];

    [infiniteLoader loadMore];

    [popoverSort dismissPopoverAnimated:YES];
}

- (void)updateLoader {
    if (searchQuery != nil && searchQuery.length > 0) {
        if (orderType != nil) {
            infiniteLoader = [TPInfiniteLoader loaderWithClass:[User class] filterParams:@{@"limit": @32, @"ordering": orderType, @"search": searchQuery,} andDelegate:self];
            self.sortLabel.text = [NSString stringWithFormat:@"Сортировка (%@)", sortTypeNameMapping[orderType]];
        } else {
            infiniteLoader = [TPInfiniteLoader loaderWithClass:[User class] filterParams:@{@"limit": @32, @"search": searchQuery,} andDelegate:self];
        }
    } else if (orderType != nil) {
        infiniteLoader = [TPInfiniteLoader loaderWithClass:[User class] filterParams:@{@"limit": @32, @"ordering": orderType,} andDelegate:self];
        self.sortLabel.text = [NSString stringWithFormat:@"Сортировка (%@)", sortTypeNameMapping[orderType]];
    } else {
        infiniteLoader = [TPInfiniteLoader loaderWithClass:[User class] filterParams:@{@"limit": @32} andDelegate:self];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > (scrollView.contentSize.height * 0.8)) {
        [infiniteLoader loadMore];
    }
}

@end
