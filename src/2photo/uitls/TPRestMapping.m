//
//  TPRestMapping.m
//  2photo
//
//  Created by smolin_in on 01/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPRestMapping.h"
#import "Post.h"
#import "User.h"
#import "Artist.h"
#import "PostCategory.h"
#import "Comment.h"
#import "NSObject+Extensions.h"

@implementation TPRestMapping

static NSDictionary* resourcesMapping;

+ (void)initialize {
    [super initialize];

    resourcesMapping = @{[Post clsName]: @"posts",
                         [User clsName]: @"authors",
                         [Artist clsName]: @"artists",
                         [PostCategory clsName]: @"categories",
                         [Comment clsName]: @"comments",};
}

+ (NSString *)resourceNameForClass:(Class)cls {
    return resourcesMapping[[cls clsName]];
}

@end
