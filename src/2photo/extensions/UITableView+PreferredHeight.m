//
//  UITableView+PreferredHeight.m
//  2photo
//
//  Created by smolin_in on 04/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "UITableView+PreferredHeight.h"

@implementation UITableView (PreferredHeight)

- (CGFloat)optimalHeight {
    CGFloat sum = 0;

    const NSInteger sectionsCount = [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] ? [self.dataSource numberOfSectionsInTableView:self] : 1;

    const BOOL respondToSectionHeight = [self.dataSource respondsToSelector:@selector(tableView:heightForHeaderInSection:)];

    for (NSInteger section = 0; section < sectionsCount; ++section) {
        sum += respondToSectionHeight ? [self.delegate tableView:self heightForHeaderInSection:section] : 44;

        for (NSInteger row = 0; row < [self.dataSource tableView:self numberOfRowsInSection:section]; ++row) {
            sum += [self.delegate tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }

    return sum;
}


@end
