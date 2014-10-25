//
//  TPAuthorSearchTableViewCell.h
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "TPBasicTableViewCell.h"

@interface TPAuthorTableViewCell : TPBasicTableViewCell

@property (nonatomic, strong) User* author;

@end
