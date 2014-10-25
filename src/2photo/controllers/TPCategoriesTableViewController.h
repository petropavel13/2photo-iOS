//
//  TPCategoriesTableViewController.h
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCategory.h"
#import "TPObjectSelectedDelegate.h"

@interface TPCategoriesTableViewController : UITableViewController

@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) PostCategory* selectedCategory;
@property (nonatomic, weak) id<TPObjectSelectedDelegate> selectionDelegate;

@end
