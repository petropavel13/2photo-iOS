//
//  User+Parser.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "User+Parser.h"
#import "Post+Parser.h"
#import "Comment+Parser.h"
#import "NSDate+Parser.h"

@implementation User (Parser)

static NSString * const idKey = @"id";
static NSString * const nameKey = @"name";
static NSString * const regDateKey = @"reg_date";
static NSString * const lastVisitDateKey = @"last_visit";
static NSString * const countryKey = @"country";
static NSString * const cityKey = @"city";
static NSString * const siteKey = @"site";
static NSString * const emailKey = @"email";
static NSString * const carmaKey = @"carma";
static NSString * const avatarUrlKey = @"avatar_url";
static NSString * const numberOfPostsKey = @"number_of_posts";
static NSString * const numberOfCommentsKey = @"number_of_comments";
static NSString * const descriptionKey = @"description";

static NSString * const postsKey = @"posts";
static NSString * const commentsKey = @"comments";

+ (instancetype)objectWithId:(NSNumber*)objId {
    User* obj = [self managedObjectWithContext:[TPManagedObjectContext sharedContext]];
    obj.id = objId;

    return obj;
}

+ (instancetype)objectFromJSON:(id)JSON {
    User* obj = [self objectWithId:JSON[idKey]];
    obj.name = JSON[nameKey];
    obj.registrationDate = [NSDate dateFromString:JSON[regDateKey]];
    obj.lastVisit = [NSDate dateTimeFromString:JSON[lastVisitDateKey]];
    obj.country = [JSON[countryKey] nilIfNull];
    obj.city = [JSON[cityKey] nilIfNull];
    obj.site = [JSON[siteKey] nilIfNull];
    obj.email = [JSON[emailKey] nilIfNull];
    obj.carma = JSON[carmaKey];
    obj.avatarUrl = JSON[avatarUrlKey];
    obj.numberOfPosts = JSON[numberOfPostsKey];
    obj.numberOfComments = JSON[numberOfCommentsKey];
    obj.userDescription = [JSON[descriptionKey] nilIfNull];

    return obj;
}

+ (instancetype)detailObjectFromJSON:(id)JSON {
    User* obj = [self objectFromJSON:JSON];

    for (id post in JSON[postsKey]) {
        [obj addPostsObject:[post isKindOfClass:[NSNumber class]] ? [Post objectWithId:post] : [Post objectFromJSON:post]];
    }

    for (id comment in JSON[commentsKey]) {
        [obj addCommentsObject:[comment isKindOfClass:[NSNumber class]] ? [Comment objectWithId:comment] : [Comment objectFromJSON:comment]];
    }

    return obj;
}

@end
