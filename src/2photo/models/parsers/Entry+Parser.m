//
//  Entry+Parser.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "Entry+Parser.h"
#import "Post+Parser.h"

@implementation Entry (Parser)

static NSString * const idKey = @"id";
static NSString * const descriptionKey = @"description";
static NSString * const ratingKey = @"rating";
static NSString * const bigImageUrlKey = @"big_img_url";
static NSString * const mediumImageUrlKey = @"medium_img_url";
static NSString * const postKey = @"post";
static NSString * const orderKey = @"order";

+ (instancetype)objectWithId:(NSNumber*)objId {
    Entry* obj = [self managedObjectWithContext:[TPManagedObjectContext sharedContext]];
    obj.id = objId;

    return obj;
}

+ (instancetype)objectFromJSON:(id)JSON {
    Entry* obj = [self objectWithId:JSON[idKey]];
    obj.entryDescription = JSON[descriptionKey];
    obj.rating = JSON[ratingKey];
    obj.mediumImageUrl = JSON[mediumImageUrlKey];
    obj.bigImageUrl = JSON[bigImageUrlKey];
    obj.post = [Post objectFromJSON:JSON[postKey]];
    obj.order = JSON[orderKey];

    return obj;
}

+ (instancetype)detailObjectFromJSON:(id)JSON {
    return [self objectFromJSON:JSON];
}

@end
