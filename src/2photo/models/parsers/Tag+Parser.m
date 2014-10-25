//
//  Tag+Parser.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "Tag+Parser.h"

@implementation Tag (Parser)

static NSString * const idKey = @"id";
static NSString * const titleKey = @"title";

+ (instancetype)objectWithId:(NSNumber*)objId {
    Tag* obj = [self managedObjectWithContext:[TPManagedObjectContext sharedContext]];
    obj.id = objId;

    return obj;
}

+ (instancetype)objectFromJSON:(id)JSON {
    Tag* obj = [self objectWithId:JSON[idKey]];
    obj.title = JSON[titleKey];

    return obj;
}

+ (instancetype)detailObjectFromJSON:(id)JSON {
    return [self objectFromJSON:JSON];
}

@end
