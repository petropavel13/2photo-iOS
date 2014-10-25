//
//  TPPostDetailTableViewController.m
//  2photo
//
//  Created by smolin_in on 26/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPPostDetailTableViewController.h"
#import "PostCategory.h"
#import "Tag.h"
#import "TPEntryThumbnailCollectionViewCell.h"
#import "UILabel+Extensions.h"
#import <tgmath.h>
#import "TPTagCollectionViewCell.h"
#import "TPEntryDetailViewController.h"
#import "TPAppConstants.h"
#import <SDImageCache.h>
#import "TPCommentsTableView.h"
#import "AFHTTPRequestOperation+Extensions.h"
#import "Post+Parser.h"
#import <WYPopoverController.h>
#import "TPPostInfoTableViewController.h"
#import "TPObjectSelectedDelegate.h"
#import "UITableView+PreferredHeight.h"
#import "TPAuthorDetailViewController.h"
#import "TPArtistDetailViewController.h"
#import "AFHTTPRequestOperation+Extensions.h"
#import "TPRestMapping.h"
#import "User+Parser.h"
#import "Artist+Parser.h"

@interface TPPostDetailTableViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TPObjectSelectedDelegate, UIAlertViewDelegate> {
    NSArray* sortedEntries;
    NSArray* categories;
    NSArray* tags;

    TPTagCollectionViewCell* sharedCell;

    WYPopoverController* popoverInfo;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *entriesCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *tagsCollectionView;
@property (strong, nonatomic) IBOutlet TPCommentsTableView *commentsTableView;

- (IBAction)infoButtonClicked:(UIBarButtonItem *)sender;

@end

@implementation TPPostDetailTableViewController

static NSString * const entryThumbnailCollectionCellIdentifier = @"entry_thumbnail_cell";
static NSString * const categoryCellIdentifier = @"category_cell";
static NSString * const tagCellIdentifier = @"tag_cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    sortedEntries = [_post.entries sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];

    categories = _post.categories.allObjects;
    tags = _post.tags.allObjects;

    const CGFloat minWidth = MIN(CGRectGetHeight(self.tableView.frame), CGRectGetWidth(self.tableView.frame)) - 32;

    self.titleLabel.text = _post.title;
    self.titleLabel.numberOfLines = [self.titleLabel optimalNumberOfLinesForWidth:minWidth];

    self.descriptionLabel.text = _post.postDescription;
    self.descriptionLabel.numberOfLines = [self.descriptionLabel optimalNumberOfLinesForWidth:minWidth];

    NSMutableArray* tagsTitles = [NSMutableArray array];

    for (Tag* t in _post.tags) {
        [tagsTitles addObject:t.title];
    }

    NSMutableArray* categoriesTitles = [NSMutableArray array];

    for (PostCategory* c in _post.categories) {
        [categoriesTitles addObject:c.title];
    }

    NSBundle* bundle = [NSBundle mainBundle];

    [self.entriesCollectionView registerNib:[UINib nibWithNibName:@"TPEntryThumbnailCollectionViewCell" bundle:bundle] forCellWithReuseIdentifier:entryThumbnailCollectionCellIdentifier];
    [self.categoriesCollectionView registerNib:[UINib nibWithNibName:@"TPTagCollectionViewCell" bundle:bundle] forCellWithReuseIdentifier:categoryCellIdentifier];
    [self.tagsCollectionView registerNib:[UINib nibWithNibName:@"TPTagCollectionViewCell" bundle:bundle] forCellWithReuseIdentifier:tagCellIdentifier];

    sharedCell = [[bundle loadNibNamed:@"TPTagCollectionViewCell" owner:self options:nil] firstObject];

    id detailPostJSON = [AFHTTPRequestOperation synchroniousRequestJSONFromUrl:[apiUrl stringByAppendingString:[NSString stringWithFormat:@"posts/%@/", _post.id.stringValue]]];
    _post = [Post detailObjectFromJSON:detailPostJSON];
    
    self.commentsTableView.comments = _post.comments.allObjects;

    TPPostInfoTableViewController* infoController = [[TPPostInfoTableViewController alloc] initWithStyle:UITableViewStylePlain];
    infoController.post = _post;
    infoController.selectionDelegate = self;
//    infoController.preferredContentSize = CGSizeMake(320, 320);

    popoverInfo = [[WYPopoverController alloc] initWithContentViewController:infoController];
    popoverInfo.theme.fillTopColor = [UIColor darkGrayColor];
    popoverInfo.theme.fillBottomColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] clearMemory];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger row = indexPath.row;

    if (row == 0) { // title
        return [self.titleLabel optimalSizeForWidth:CGRectGetWidth(tableView.frame) - 16.f * 2].height + 8 * 2;
    } else if (row == 1) { // description
        return [self.descriptionLabel optimalSizeForWidth:CGRectGetWidth(tableView.frame) - 16.f * 2].height + 8 * 2;
    } else if (row == 2) { // photos
        const CGFloat width = CGRectGetWidth(tableView.frame);
        NSUInteger columns = (NSUInteger)width / 232;
        NSUInteger rows = ceil((CGFloat)[self.entriesCollectionView.dataSource collectionView:self.entriesCollectionView numberOfItemsInSection:0] / (CGFloat)columns);

        return rows * 256 + 22 * (rows - 1) + 8 * 2;
    } else if (row == 3) { // categories
        return 52;
    } else if (row == 4) { // tags
        return 52;
    } else if (row == 5) { // comments
        return self.commentsTableView.optimalHeight + 8 * 2;
    }

    return 256;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = nil;

    if ([collectionView isEqual:self.entriesCollectionView]) {
        TPEntryThumbnailCollectionViewCell* targetCell = (TPEntryThumbnailCollectionViewCell*) (cell = [collectionView dequeueReusableCellWithReuseIdentifier:entryThumbnailCollectionCellIdentifier forIndexPath:indexPath]);
        targetCell.entry = sortedEntries[indexPath.row];

    } else if ([collectionView isEqual:self.categoriesCollectionView]) {
        TPTagCollectionViewCell* targetCell = (TPTagCollectionViewCell*) (cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCellIdentifier forIndexPath:indexPath]);
        targetCell.postCategory = categories[indexPath.row];

    } else if ([collectionView isEqual:self.tagsCollectionView]) {
        TPTagCollectionViewCell* targetCell = (TPTagCollectionViewCell*) (cell = [collectionView dequeueReusableCellWithReuseIdentifier:tagCellIdentifier forIndexPath:indexPath]);
        targetCell.postTag = tags[indexPath.row];
    }

    cell.selectedBackgroundView.backgroundColor = darknessGray;

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.entriesCollectionView]) {
        return sortedEntries.count;
    } else if ([collectionView isEqual:self.categoriesCollectionView]) {
        return categories.count;
    } else if ([collectionView isEqual:self.tagsCollectionView]) {
        return tags.count;
    }

    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger row = indexPath.row;

    if ([collectionView isEqual:self.entriesCollectionView]) {
        return CGSizeMake(232, 256);
    } else if ([collectionView isEqual:self.categoriesCollectionView]) {
        @synchronized(sharedCell) {
            sharedCell.postCategory = categories[row];
            return sharedCell.optimalSize;
        }
    } else if ([collectionView isEqual:self.tagsCollectionView]) {
        @synchronized(sharedCell) {
            sharedCell.postTag = tags[row];
            return sharedCell.optimalSize;
        }

    }

    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.entriesCollectionView]) {
        TPEntryDetailViewController* browser = [[TPEntryDetailViewController alloc] init];
        browser.post = _post;
        browser.selectedEntry = indexPath.row;

        [self.navigationController pushViewController:browser animated:YES];
    }
}

- (IBAction)infoButtonClicked:(UIBarButtonItem *)sender {
    [popoverInfo presentPopoverFromBarButtonItem:sender
                        permittedArrowDirections:WYPopoverArrowDirectionAny
                                        animated:YES];
}

- (void)objectSelected:(id)object inController:(id)controller {
    if ([object isKindOfClass:[NSString class]]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Переход по ссылке"
                                                        message:@"Открыть ссылку в браузере?"
                                                       delegate:self
                                              cancelButtonTitle:@"Нет"
                                              otherButtonTitles:@"Да", nil];
        alert.userInfoData = object;
        [alert show];
    } else if ([object isKindOfClass:[User class]]) {
        TPAuthorDetailViewController* authorController = [currentStoryboard instantiateViewControllerWithIdentifier:authorDetailControllerIdentifier];
        User* obj = object;
        NSString* url = [[apiUrl stringByAppendingString:[TPRestMapping resourceNameForClass:[User class]]] stringByAppendingString:[NSString stringWithFormat:@"/%@/", obj.id]];
        authorController.author = [User detailObjectFromJSON:[AFHTTPRequestOperation synchroniousRequestJSONFromUrl:url]];

        [popoverInfo dismissPopoverAnimated:YES completion:^{
            [self.navigationController pushViewController:authorController animated:YES];
        }];

    } else if ([object isKindOfClass:[Artist class]]) {
        TPArtistDetailViewController* artistController = [currentStoryboard instantiateViewControllerWithIdentifier:artistDetailControllerIdentifier];
        Artist* obj = object;
        NSString* url = [[apiUrl stringByAppendingString:[TPRestMapping resourceNameForClass:[Artist class]]] stringByAppendingString:[NSString stringWithFormat:@"/%@/", obj.id]];
        artistController.artist = [Artist detailObjectFromJSON:[AFHTTPRequestOperation synchroniousRequestJSONFromUrl:url]];

        [popoverInfo dismissPopoverAnimated:YES completion:^{
            [self.navigationController pushViewController:artistController animated:YES];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.userInfoData]];
    }
}

@end
