//
//  TPPostInfoTableViewController.m
//  2photo
//
//  Created by smolin_in on 02/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPPostInfoTableViewController.h"
#import "User.h"
#import "Artist.h"
#import "NSObject+Extensions.h"
#import "TPAuthorTableViewCell.h"
#import "TPArtistTableViewCell.h"
#import "TPBasicTableViewCell.h"

@interface TPPostInfoTableViewController () {
    NSDictionary* sectionsData;

    NSDictionary* indexTypeMapping;
    NSDictionary* typeIndexMapping;
    NSDictionary* sectionTitles;
}

@end

@implementation TPPostInfoTableViewController

static NSString * const authorCellIdentifier = @"author_cell";
static NSString * const artistCellIdentifier = @"artist_cell";
static NSString * const siteCellIdentifier = @"site_cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    BOOL hasArtists = _post.artists.count > 0;
    BOOL hasSite = _post.link.length > 0;

    if ((!hasArtists && hasSite) || (hasArtists && !hasSite)) {
        if (hasArtists) {
            indexTypeMapping = @{@(0): [User clsName],
                                 @(1): [Artist clsName],};

            typeIndexMapping = @{[User clsName]: @(0),
                                 [Artist clsName]: @(1),};

            sectionTitles = @{@(0): @"Автор",
                              @(1): _post.artists.count > 1 ? @"Творцы" : @"Творец",};

            sectionsData = @{[User clsName]: @[_post.author],
                             [Artist clsName]: _post.artists.allObjects,};

        } else if (hasSite) {
            indexTypeMapping = @{@(0): [User clsName],
                                 @(1): [NSString clsName],};

            typeIndexMapping = @{[User clsName]: @(0),
                                 [NSString clsName]: @(1),};

            sectionTitles = @{@(0): @"Автор",
                              @(1): @"Сайт",};

            sectionsData = @{[User clsName]: @[_post.author],
                             [NSString clsName]: @[_post.link],};

        }
    } else if (!hasArtists && !hasSite) {
        indexTypeMapping = @{@(0): [User clsName],};

        typeIndexMapping = @{[User clsName]: @(0),};

        sectionTitles = @{@(0): @"Автор",};

        sectionsData = @{[User clsName]: @[_post.author],};
    } else {
        indexTypeMapping = @{@(0): [User clsName],
                             @(1): [Artist clsName],
                             @(2): [NSString clsName],};

        typeIndexMapping = @{[User clsName]: @(0),
                             [Artist clsName]: @(1),
                             [NSString clsName]: @(2),};

        sectionTitles = @{@(0): @"Автор",
                          @(1): @"Личности",
                          @(2): @"Сайт",};

        sectionsData = @{[User clsName]: @[_post.author],
                         [Artist clsName]: _post.artists.allObjects,
                         [NSString clsName]: @[_post.link]};
    }

    NSBundle* bundle = [NSBundle mainBundle];

    [self.tableView registerNib:[UINib nibWithNibName:@"TPAuthorTableViewCell" bundle:bundle] forCellReuseIdentifier:authorCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TPArtistTableViewCell" bundle:bundle] forCellReuseIdentifier:artistCellIdentifier];
    [self.tableView registerClass:[TPBasicTableViewCell class] forCellReuseIdentifier:siteCellIdentifier];

    self.tableView.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:32 / 255.0 blue:32 / 255.0 alpha:0.96];
    self.tableView.separatorColor = [UIColor darkGrayColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* type = indexTypeMapping[@(section)];

    return [(NSArray*)sectionsData[type] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* type = indexTypeMapping[@(indexPath.section)];

    id obj = sectionsData[type][indexPath.row];

    UITableViewCell *cell = nil;

    if ([type isEqualToString:[User clsName]]) {
        TPAuthorTableViewCell* targetCell = (TPAuthorTableViewCell*)(cell = [tableView dequeueReusableCellWithIdentifier:authorCellIdentifier]);
        targetCell.author = obj;
    } else if ([type isEqualToString:[Artist clsName]]) {
        TPArtistTableViewCell* targetCell = (TPArtistTableViewCell*)(cell = [tableView dequeueReusableCellWithIdentifier:artistCellIdentifier]);
        targetCell.artist = obj;
    } else if ([type isEqualToString:[NSString clsName]]) {
        cell = [[TPBasicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:siteCellIdentifier];
        cell.textLabel.text = obj;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sectionTitles[@(section)];
}

- (CGSize)preferredContentSize {
    CGFloat sum = 0;

    for (NSUInteger section = 0; section < [self numberOfSectionsInTableView:self.tableView]; ++section) {
        sum += 20;

        for (NSUInteger row = 0; row < [self tableView:self.tableView numberOfRowsInSection:section]; ++row) {
            sum += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }

    return CGSizeMake(320, sum);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* type = indexTypeMapping[@(indexPath.section)];

    [self.selectionDelegate objectSelected:sectionsData[type][indexPath.row] inController:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
