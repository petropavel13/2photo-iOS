//
//  TPArtistDetailTableViewCell.h
//  2photo
//
//  Created by smolin_in on 10/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPBasicTableViewCell.h"
#import "Artist.h"

@interface TPArtistDetailTableViewCell : TPBasicTableViewCell

@property (nonatomic, strong) Artist* artist;

@end
