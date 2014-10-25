//
//  TPArtistDetailViewController.h
//  2photo
//
//  Created by smolin_in on 11/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@interface TPArtistDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Artist* artist;

@end
