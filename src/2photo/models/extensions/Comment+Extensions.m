//
//  Comment+Extensions.m
//  2photo
//
//  Created by smolin_in on 27/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "Comment+Extensions.h"

@implementation Comment (Extensions)

- (NSUInteger)countOfParentComments {
    return self.replyTo == nil ? 0 : 1 + self.replyTo.countOfParentComments;
}

+ (NSMutableArray *)sortCommentsWithParent:(Comment *)parent others:(NSArray *)others {
    NSArray* childs = [others filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"replyTo.id == %@", parent.id]];

    childs = [childs sortedArrayUsingComparator:^NSComparisonResult(Comment* c0, Comment* c1) {
        return [c0.date compare:c1.date];
    }];

    NSMutableArray* results = parent == nil ? [@[] mutableCopy] : [NSMutableArray arrayWithObject:parent];

    for (Comment* child in childs) {
        [results addObjectsFromArray:[self sortCommentsWithParent:child others:others]];
    }

    return results;
}

- (NSUInteger)countOfParentsCommentsInComments:(NSArray*)comments {
    Comment* c = [[comments filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id == %@", self.replyTo.id]] firstObject];

    return c == nil ? 0 : 1 + [c countOfParentsCommentsInComments:comments];
}

@end
