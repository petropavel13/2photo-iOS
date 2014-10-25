//
//  PostCategory+Parser.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "PostCategory+Parser.h"

@implementation PostCategory (Parser)

static NSString * const idKey = @"id";
static NSString * const titleKey = @"title";

+ (instancetype)objectWithId:(NSNumber*)objId {
    PostCategory* obj = [self managedObjectWithContext:[TPManagedObjectContext sharedContext]];
    obj.id = objId;

    return obj;
}

+ (instancetype)objectFromJSON:(id)JSON {
    PostCategory* obj = [self objectWithId:JSON[idKey]];
    obj.title = JSON[titleKey];

    return obj;
}

+ (instancetype)detailObjectFromJSON:(id)JSON {
    return [self objectFromJSON:JSON];
}

@end
