//
//  TPSortTypeTableViewController.m
//  2photo
//
//  Created by smolin_in on 03/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPSortTypeTableViewController.h"
#import "TPBasicTableViewCell.h"
#import "TPAppConstants.h"

@interface TPSortTypeTableViewController () {
    NSArray* titles;
    NSArray* types;
}

@end

@implementation TPSortTypeTableViewController

static NSString * const orderTypeCellIdentifier = @"order_type_cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[TPBasicTableViewCell class] forCellReuseIdentifier:orderTypeCellIdentifier];

    types = [_typeNameMapping.allKeys sortedArrayUsingSelector: @selector(compare:)];

    NSMutableArray* mutableTitles = [NSMutableArray arrayWithCapacity:types.count];

    for (id type in types) {
        [mutableTitles addObject:_typeNameMapping[type]];
    }

    titles = [mutableTitles copy];

    self.tableView.backgroundColor = darknessGray;
    self.tableView.separatorColor = [UIColor darkGrayColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id type = types[indexPath.row];

    TPBasicTableViewCell *cell = (TPBasicTableViewCell*) [tableView dequeueReusableCellWithIdentifier:orderTypeCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = titles[indexPath.row];
    cell.accessoryType = [type isEqual:_selectedType] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedType = types[indexPath.row];
    [_selectionDelegate objectSelected:_selectedType inController:self];

    [self.tableView reloadData];
}


- (CGSize)preferredContentSize {
    CGFloat sum = 0;

    for (NSUInteger row = 0; row < [self.tableView numberOfRowsInSection:0]; ++row) {
        sum += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    }

    return CGSizeMake(320, sum);
}


@end
