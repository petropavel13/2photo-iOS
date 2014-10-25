//
//  Artist+Parser.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "Artist+Parser.h"
#import "Post+Parser.h"

@implementation Artist (Parser)

static NSString * const idKey = @"id";
static NSString * const nameKey = @"name";
static NSString * const avatarUrlKey = @"avatar_url";
static NSString * const descriptionKey = @"description";
static NSString * const numberOfPostsKey = @"number_of_posts";

static NSString * const postsKey = @"posts";

+ (instancetype)objectWithId:(NSNumber*)objId {
    Artist* obj = [self managedObjectWithContext:[TPManagedObjectContext sharedContext]];
    obj.id = objId;

    return obj;
}

+ (instancetype)objectFromJSON:(id)JSON {
    Artist* obj = [self objectWithId:JSON[idKey]];
    obj.name = JSON[nameKey];
    obj.avatarUrl = JSON[avatarUrlKey];
    obj.artistDescription = [JSON[descriptionKey] nilIfNull];
    obj.numberOfPosts = JSON[numberOfPostsKey];

    return obj;
}

+ (instancetype)detailObjectFromJSON:(id)JSON {
    Artist* obj = [self objectFromJSON:JSON];

    for (id post in JSON[postsKey]) {
        [obj addPostsObject: [post isKindOfClass:[NSNumber class]] ? [Post objectWithId:post] : [Post objectFromJSON:post]];
    }

    return obj;
}

@end
