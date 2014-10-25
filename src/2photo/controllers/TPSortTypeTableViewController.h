//
//  TPSortTypeTableViewController.h
//  2photo
//
//  Created by smolin_in on 03/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPObjectSelectedDelegate.h"

@interface TPSortTypeTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary* typeNameMapping;
@property (nonatomic, strong) id selectedType;

@property (nonatomic, weak) id<TPObjectSelectedDelegate> selectionDelegate;

@end
