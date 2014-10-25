//
//  Comment+Parser.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "Comment+Parser.h"
#import "User+Parser.h"
#import "Post+Parser.h"
#import "NSDate+Parser.h"

@implementation Comment (Parser)

static NSString * const idKey = @"id";
static NSString * const messageKey = @"message";
static NSString * const dateKey = @"date";
static NSString * const replyToKey = @"reply_to";
static NSString * const ratingKey = @"rating";
static NSString * const authorKey = @"author";
static NSString * const postKey = @"post";

+ (instancetype)objectWithId:(NSNumber*)objId {
    Comment* obj = [self managedObjectWithContext:[TPManagedObjectContext sharedContext]];
    obj.id = objId;

    return obj;
}

+ (instancetype)objectFromJSON:(id)JSON {
    Comment* obj = [self objectWithId:JSON[idKey]];
    obj.message = JSON[messageKey];
    obj.date = [NSDate dateTimeFromString:JSON[dateKey]];
    obj.rating = JSON[ratingKey];
    id author = JSON[authorKey];
    obj.author = [author isKindOfClass:[NSNumber class]] ? [User objectWithId:author] : [User objectFromJSON:author];
    id post = JSON[postKey];
    obj.post = [post isKindOfClass:[NSNumber class]] ? [Post objectWithId:post] : [Post objectFromJSON:post];
    id replyToComment = [JSON[replyToKey] nilIfNull];

    if (replyToComment != nil) {
        obj.replyTo = [replyToComment isKindOfClass:[NSNumber class]] ? [Comment objectWithId:replyToComment] : [Comment objectFromJSON:replyToComment];
    } else {
        obj.replyTo = nil;
    }

    return obj;
}

+ (instancetype)detailObjectFromJSON:(id)JSON {
    return [self objectFromJSON:JSON];
}

@end
