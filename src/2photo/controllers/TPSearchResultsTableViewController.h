//
//  TPSearchResultsTableViewController.h
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPObjectSelectedDelegate.h"

@interface TPSearchResultsTableViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, weak) id<TPObjectSelectedDelegate> searchDelegate;

@end
