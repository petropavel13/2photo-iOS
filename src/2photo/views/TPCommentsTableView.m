//
//  TPCommentsTableView.m
//  2photo
//
//  Created by smolin_in on 27/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPCommentsTableView.h"
#import "Comment+Extensions.h"
#import "TPCommentTableViewCell.h"
#import "Comment+Extensions.h"

@interface TPCommentsTableView () <UITableViewDataSource, UITableViewDelegate> {
    TPCommentTableViewCell* sharedCell;
}

@end

@implementation TPCommentsTableView

static NSString * const commentCellReuseIdentifier = @"comment_cell";

- (void)awakeFromNib {
    [super awakeFromNib];

    [self registerNib:[UINib nibWithNibName:@"TPCommentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:commentCellReuseIdentifier];

    sharedCell = [[[NSBundle mainBundle] loadNibNamed:@"TPCommentTableViewCell" owner:self options:nil] firstObject];

    self.dataSource = self;
    self.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPCommentTableViewCell* cell = (TPCommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:commentCellReuseIdentifier];

    cell.comment = _comments[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @synchronized(sharedCell) {
        sharedCell.comment = _comments[indexPath.row];
        return [sharedCell optimalHeightForWidth:CGRectGetWidth(tableView.frame)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [(Comment*)_comments[indexPath.row] countOfParentsCommentsInComments:_comments];
}

- (void)setComments:(NSArray *)comments {
    _comments = [Comment sortCommentsWithParent:nil others:comments];
}

@end
