//
//  Comment+Extensions.h
//  2photo
//
//  Created by smolin_in on 27/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "Comment.h"

@interface Comment (Extensions)

@property (nonatomic, readonly) NSUInteger countOfParentComments;

+ (NSMutableArray *)sortCommentsWithParent:(Comment *)parent others:(NSArray *)others;

- (NSUInteger)countOfParentsCommentsInComments:(NSArray*)comments;

@end
