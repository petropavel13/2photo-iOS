//
//  TPArtistSearchTableViewCell.h
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"
#import "TPBasicTableViewCell.h"

@interface TPArtistTableViewCell : TPBasicTableViewCell

@property (nonatomic, strong) Artist* artist;

@end
