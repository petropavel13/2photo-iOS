//
//  TPCategoriesTableViewController.m
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPCategoriesTableViewController.h"
#import "PostCategory.h"
#import "TPManagedObjectContext.h"
#import "NSManagedObject+Extensions.h"
#import "TPAppConstants.h"

@interface TPCategoriesTableViewController () {
    NSArray* internalCategories;
}

@end

@implementation TPCategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PostCategory* dummyCategory = [PostCategory managedObjectInsertedInContext:[TPManagedObjectContext sharedContext]];
    dummyCategory.title = @"Все категории";
    dummyCategory.id = @(-1);

    internalCategories = [@[dummyCategory] arrayByAddingObjectsFromArray:_categories];
    _selectedCategory = _selectedCategory == nil ? dummyCategory : _selectedCategory;
    self.tableView.backgroundColor = darknessGray;
    self.tableView.separatorColor = [UIColor darkGrayColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return internalCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"category_cell"];

    PostCategory* obj = internalCategories[indexPath.row];

    cell.textLabel.text = obj.title;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    UIView* bg = [UIView new];
    bg.backgroundColor = [UIColor darkGrayColor];
    cell.backgroundView = nil;
    [cell setSelectedBackgroundView:bg];

    cell.accessoryType = [obj isEqual:_selectedCategory] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCategory* category = internalCategories[indexPath.row];

    if ([category.id isEqualToNumber:@(-1)]) {
        [_selectionDelegate objectSelected:nil inController:self];
    } else {
        [_selectionDelegate objectSelected:category inController:self];
    }

    _selectedCategory = category;
    [self.tableView reloadData];
}


@end
