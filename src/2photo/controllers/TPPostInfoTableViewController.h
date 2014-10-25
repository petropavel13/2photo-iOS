//
//  TPPostInfoTableViewController.h
//  2photo
//
//  Created by smolin_in on 02/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "TPObjectSelectedDelegate.h"


@interface TPPostInfoTableViewController : UITableViewController

@property (nonatomic, strong) Post* post;

@property (nonatomic, weak) id<TPObjectSelectedDelegate> selectionDelegate;

@end
