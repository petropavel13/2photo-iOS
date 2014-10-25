//
//  TPAuthorDetailViewController.h
//  2photo
//
//  Created by smolin_in on 09/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface TPAuthorDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User* author;

@end
