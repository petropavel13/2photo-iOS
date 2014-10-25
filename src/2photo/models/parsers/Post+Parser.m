//
//  Post+Parser.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "Post+Parser.h"
#import "User+Parser.h"
#import "Comment+Parser.h"
#import "Artist+Parser.h"
#import "NSDate+Parser.h"
#import "Tag+Parser.h"
#import "PostCategory+Parser.h"
#import "Entry+Parser.h"

@implementation Post (Parser)

static NSString * const idKey = @"id";
static NSString * const titleKey = @"title";
static NSString * const authorKey = @"author";
static NSString * const descriptionKey = @"description";
static NSString * const linkKey = @"link";
static NSString * const dateKey = @"date";
static NSString * const ratingKey = @"rating";
static NSString * const faceImageUrlKey = @"face_image_url";
static NSString * const numberOfCommentsKey = @"number_of_comments";

static NSString * const entriesKey = @"entries";
static NSString * const tagsKey = @"tags";
static NSString * const categoriesKey = @"categories";
static NSString * const artistsKey = @"artists";
static NSString * const commentsKey = @"comments";


+ (instancetype)objectWithId:(NSNumber*)objId {
    Post* obj = [self managedObjectWithContext:[TPManagedObjectContext sharedContext]];
    obj.id = objId;

    return obj;
}

+ (instancetype)objectFromJSON:(id)JSON {
    Post* obj = [self objectWithId:JSON[idKey]];
    obj.title = JSON[titleKey];
    obj.author = [User objectFromJSON:JSON[authorKey]];
    obj.postDescription = [JSON[descriptionKey] nilIfNull];
    obj.link = [JSON[linkKey] nilIfNull];
    obj.date = [NSDate dateTimeFromString:JSON[dateKey]];
    obj.rating = JSON[ratingKey];
    obj.faceImageUrl = JSON[faceImageUrlKey];
    obj.numberOfComments = JSON[numberOfCommentsKey];

    for (id artist in JSON[artistsKey]) {
        [obj addArtistsObject:[artist isKindOfClass:[NSNumber class]] ? [Artist objectWithId:artist] : [Artist objectFromJSON:artist]];
    }

    for (id entry in JSON[entriesKey]) {
        [obj addEntriesObject:[entry isKindOfClass:[NSNumber class]] ? [Entry objectWithId:entry] : [Entry objectFromJSON:entry]];
    }

    for (id comment in JSON[commentsKey]) {
        [obj addCommentsObject:[comment isKindOfClass:[NSNumber class]] ? [Comment objectWithId:comment] : [Comment objectFromJSON:comment]];
    }

    for (id tag in JSON[tagsKey]) {
        [obj addTagsObject:[tag isKindOfClass:[NSNumber class]] ? [Tag objectWithId:tag] : [Tag objectFromJSON:tag]];
    }

    for (id category in JSON[categoriesKey]) {
        [obj addCategoriesObject:[category isKindOfClass:[NSNumber class]] ? [PostCategory objectWithId:category] : [PostCategory objectFromJSON:category]];
    }

    return obj;
}

+ (instancetype)detailObjectFromJSON:(id)JSON {
    return [self objectFromJSON:JSON];
}

@end
