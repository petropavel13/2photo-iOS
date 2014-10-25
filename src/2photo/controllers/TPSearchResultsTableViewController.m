//
//  TPSearchResultsTableViewController.m
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPSearchResultsTableViewController.h"
#import <AFHTTPRequestOperationManager.h>
#import "Post.h"
#import "User.h"
#import "Artist.h"
#import "TPRestMapping.h"
#import "TPAppConstants.h"
#import "TPListParser.h"
#import "NSObject+Extensions.h"
#import "TPAuthorTableViewCell.h"
#import "TPArtistTableViewCell.h"
#import "TPPostSearchTableViewCell.h"

@interface TPSearchResultsTableViewController () {
    AFHTTPRequestOperation* postsSearchOperation;
    AFHTTPRequestOperation* authorsSearchOperation;
    AFHTTPRequestOperation* artistsSearchOperation;

    NSMutableDictionary* sectionsData;
    NSDictionary* sectionIndexTypeMapping;
    NSDictionary* typeSectionIndexMapping;
    NSDictionary* sectionTitles;
}

@end

@implementation TPSearchResultsTableViewController

static NSString * const postCellIdentifier = @"post_cell";
static NSString * const authorCellIdentifier = @"author_cell";
static NSString * const artistCellIdentifier = @"artist_cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    NSBundle * bundle = [NSBundle mainBundle];

    [self.tableView registerNib:[UINib nibWithNibName:@"TPAuthorTableViewCell" bundle:bundle] forCellReuseIdentifier:authorCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TPArtistTableViewCell" bundle:bundle] forCellReuseIdentifier:artistCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TPPostSearchTableViewCell" bundle:bundle] forCellReuseIdentifier:postCellIdentifier];

    sectionsData = [@{} mutableCopy];

    sectionIndexTypeMapping = @{@(0): [User clsName],
                                @(1): [Artist clsName],
                                @(2): [Post clsName]};

    typeSectionIndexMapping = @{[User clsName]: @(0),
                                [Artist clsName]: @(1),
                                [Post clsName]: @(2)};

    sectionTitles = @{@(0): @"Авторы",
                      @(1): @"Личности",
                      @(2): @"Посты"};

    authorsSearchOperation = [AFHTTPRequestOperation new];
    artistsSearchOperation = [AFHTTPRequestOperation new];
    postsSearchOperation = [AFHTTPRequestOperation new];

    self.tableView.backgroundColor = popoverTransparentGray;
    self.tableView.separatorColor = [UIColor darkGrayColor];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* objects = sectionsData[sectionIndexTypeMapping[@(section)]];

    return objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* type = sectionIndexTypeMapping[@(indexPath.section)];

    id obj = sectionsData[type][indexPath.row];

    UITableViewCell* cell = nil;

    if ([type isEqualToString:[User clsName]]) {
        TPAuthorTableViewCell* targetCell = (TPAuthorTableViewCell*) (cell = [tableView dequeueReusableCellWithIdentifier:authorCellIdentifier]);
        targetCell.author = obj;
    } else if ([type isEqualToString:[Artist clsName]]) {
        TPArtistTableViewCell* targetCell = (TPArtistTableViewCell*) (cell = [tableView dequeueReusableCellWithIdentifier:artistCellIdentifier]);
        targetCell.artist = obj;
    } else if ([type isEqualToString:[Post clsName]]) {
        TPPostSearchTableViewCell* targetCell = (TPPostSearchTableViewCell*) (cell = [tableView dequeueReusableCellWithIdentifier:postCellIdentifier]);
        targetCell.post = obj;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sectionTitles[@(section)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* type = sectionIndexTypeMapping[@(indexPath.section)];

    [self.searchDelegate objectSelected:sectionsData[type][indexPath.row] inController:self];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        sectionsData = [@{} mutableCopy];
        [self.tableView reloadData];
        return;
    }

    if (searchBar.text.length < 2) return;

    for (AFHTTPRequestOperation* operaiton in @[postsSearchOperation, authorsSearchOperation, artistsSearchOperation]) {
        if (operaiton.isExecuting) {
            [operaiton cancel];
        }
    }

    __weak typeof(self) weakSelf = self;

    AFHTTPRequestOperation*(^genOperation)(NSString*, Class) = ^AFHTTPRequestOperation*(NSString* query, Class targetClass) {
        AFHTTPRequestOperation* operation = [[AFHTTPRequestOperationManager manager] GET:[apiUrl stringByAppendingString:[[TPRestMapping resourceNameForClass:targetClass] stringByAppendingString:@"/"]]
                                                                              parameters:@{@"limit": @(6),
                                                                                           @"search": query}
                                                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                     [sectionsData setObject:[TPListParser parseJSONObjects:responseObject[@"results"] ofType:targetClass]
                                                                                                      forKey:[targetClass clsName]];

                                                                                     [weakSelf.tableView reloadData];
                                                                                 }
                                                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                     //
                                                                                 }];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];

        return operation;
    };


    postsSearchOperation = genOperation(searchBar.text, [Post class]);
    authorsSearchOperation = genOperation(searchBar.text, [User class]);
    artistsSearchOperation = genOperation(searchBar.text, [Artist class]);

    for (AFHTTPRequestOperation* operaiton in @[postsSearchOperation, authorsSearchOperation, artistsSearchOperation]) {
        [operaiton start];
    }
}

@end
