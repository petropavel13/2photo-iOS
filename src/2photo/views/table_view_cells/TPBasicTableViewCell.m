//
//  TPBasicTableViewCell.m
//  2photo
//
//  Created by smolin_in on 03/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPBasicTableViewCell.h"
#import "TPAppConstants.h"

@implementation TPBasicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self applyStyle];
    }

    return self;
}

- (void)awakeFromNib {
    [self applyStyle];
}

- (void)applyStyle {
    UIView* bg = [UIView new];
    bg.backgroundColor = [UIColor darkGrayColor];

    self.selectedBackgroundView = bg;

    self.textLabel.textColor = [UIColor lightGrayColor];

    self.selectedBackgroundView.backgroundColor = darknessGray;
}

@end
