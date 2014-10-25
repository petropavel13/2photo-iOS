//
//  TPAuthorDetailTableViewCell.h
//  2photo
//
//  Created by smolin_in on 03/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPBasicTableViewCell.h"
#import "User.h"

@interface TPAuthorDetailTableViewCell : TPBasicTableViewCell

@property (nonatomic, strong) User* author;

@end
