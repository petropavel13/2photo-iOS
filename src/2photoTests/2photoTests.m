//
//  _photoTests.m
//  2photoTests
//
//  Created by smolin_in on 18/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "TPAppConstants.h"
#import "Tag+Parser.h"
#import "PostCategory+Parser.h"
#import "User+Parser.h"
#import "Comment+Parser.h"
#import "Artist+Parser.h"
#import "Entry+Parser.h"
#import "Post+Parser.h"

static NSDictionary* resourceMapping;
static NSDictionary* listParsersMapping;
static NSDictionary* detailParsersMapping;

@interface TwoPhotoTests : XCTestCase

@end

@implementation TwoPhotoTests

+ (void)initialize {
    NSString * const tag = [Tag clsName];
    NSString * const category = [PostCategory clsName];
    NSString * const user = [User clsName];
    NSString * const artist = [Artist clsName];
    NSString * const entry = [Entry clsName];
    NSString * const post = [Post clsName];
    NSString * const comment = [Comment clsName];

    resourceMapping = @{tag: @"tags",
                    category: @"categories",
                    user: @"users",
                    artist: @"artists",
                    entry: @"entries",
                    comment: @"comments",
                    post: @"posts",};

    listParsersMapping = @{tag: ^id(id jsonObj) { return [Tag objectFromJSON:jsonObj]; },
                       category: ^id(id jsonObj) { return [PostCategory objectFromJSON:jsonObj];},
                       user: ^id(id jsonObj) { return [User objectFromJSON:jsonObj]; },
                       artist: ^id(id jsonObj) { return [Artist objectFromJSON:jsonObj]; },
                       entry: ^id(id jsonObj) { return [Entry objectFromJSON:jsonObj]; },
                       comment: ^id(id jsonObj) { return [Comment objectFromJSON:jsonObj]; },
                       post: ^id(id jsonObj) { return [Post objectFromJSON:jsonObj]; },};

    detailParsersMapping = @{tag: ^id(id jsonObj) { return [Tag detailObjectFromJSON:jsonObj]; },
                           category: ^id(id jsonObj) { return [PostCategory detailObjectFromJSON:jsonObj];},
                           user: ^id(id jsonObj) { return [User detailObjectFromJSON:jsonObj]; },
                           artist: ^id(id jsonObj) { return [Artist detailObjectFromJSON:jsonObj]; },
                           entry: ^id(id jsonObj) { return [Entry detailObjectFromJSON:jsonObj]; },
                           comment: ^id(id jsonObj) { return [Comment detailObjectFromJSON:jsonObj]; },
                           post: ^id(id jsonObj) { return [Post detailObjectFromJSON:jsonObj]; },};

}

- (id)jsonResponseFromUrl:(NSString*)url {
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation start];
    [operation waitUntilFinished];

    return operation.responseObject;
}

- (id)jsonResponseForListOfObjectType:(NSString*)otype {
    return [self jsonResponseFromUrl:[NSString stringWithFormat:@"%@v1/%@/", apiUrl, resourceMapping[otype]]];
}

- (id)jsonResponseForListOfObjectType:(NSString*)otype limit:(NSUInteger)limit {
    return [self jsonResponseFromUrl:[NSString stringWithFormat:@"%@v1/%@/?limit=%@", apiUrl, resourceMapping[otype], @(limit)]][@"results"];
}

- (NSArray*)parseObjectsFromList:(id)list withType:(NSString*)otype {
    NSMutableArray* mutableArray = [NSMutableArray array];

    id(^targetParser)(id) = listParsersMapping[otype];

    for (id obj in list) {
        [mutableArray addObject:targetParser(obj)];
    }

    return [mutableArray copy];
}

- (NSArray*)loadLimitedListObjectsWithType:(NSString*)otype limit:(NSUInteger)limit {
    id objects = [self jsonResponseForListOfObjectType:otype limit:limit];
    XCTAssertNotNil(objects, @"Error when getting objects from api.");

    NSArray* arrayOfObjects = [self parseObjectsFromList:objects withType:otype];

    XCTAssertNotEqual(arrayOfObjects.count, 0, @"It's empty");

    return arrayOfObjects;
}

- (NSArray*)loadAllObjectsWithType:(NSString*)otype {
    id objects = [self jsonResponseForListOfObjectType:otype];
    XCTAssertNotNil(objects, @"Error when getting objects from api.");

    NSArray* arrayOfObjects = [self parseObjectsFromList:objects withType:otype];

    XCTAssertNotEqual(arrayOfObjects.count, 0, @"It's empty");

    return arrayOfObjects;
}

- (void)testLoadAllCategories {
    [self loadAllObjectsWithType:[PostCategory clsName]];
}

- (void)testLoadAllTags {
    [self loadAllObjectsWithType:[Tag clsName]];
}

- (void)testLoadLimitedTagsList {
    [self loadLimitedListObjectsWithType:[Tag clsName] limit:128];
}

- (void)testLoadLimitedPostsList {
    [self loadLimitedListObjectsWithType:[Post clsName] limit:128];
}

- (void)testLoadLimitedUsersList {
    [self loadLimitedListObjectsWithType:[User clsName] limit:128];
}

- (void)testLoadAllArtists {
    [self loadAllObjectsWithType:[Artist clsName]];
}

- (void)testLoadAllUserComments {
    User* u = [[self loadLimitedListObjectsWithType:[User clsName] limit:16] lastObject];

    XCTAssertNotNil(u, @"Failed to load user");

    id comments = [self jsonResponseFromUrl:[NSString stringWithFormat:@"%@v1/%@/?author=%@", apiUrl, resourceMapping[[Comment clsName]], u.id]];

    XCTAssertNotNil(comments, @"Failed to load comments for user");

    NSArray* arrayOfComments = [self parseObjectsFromList:comments withType:[Comment clsName]];

    XCTAssertNotEqual(arrayOfComments.count, 0, @"It's empty");
}

- (void)testLoadAllUserPosts {
    id posts = [self jsonResponseFromUrl:[NSString stringWithFormat:@"%@v1/%@/?author=%@", apiUrl, resourceMapping[[Post clsName]], @12502]];

    XCTAssertNotNil(posts, @"Failed to load posts for user");

    NSArray* arrayOfPosts = [self parseObjectsFromList:posts withType:[Post clsName]];

    XCTAssertNotEqual(arrayOfPosts.count, 0, @"It's empty");
}

- (void)testLoadPostDetail {
    id post = [self jsonResponseFromUrl:[NSString stringWithFormat:@"%@v1/%@/%@/", apiUrl, resourceMapping[[Post clsName]], @32295]];

    XCTAssertNotNil(post, @"Failed to load post detail");

    XCTAssertNotNil([Post detailObjectFromJSON:post], @"Failed to parse post detail");
}

- (void)testLoadPostsForTag {
    id posts = [self jsonResponseFromUrl:[NSString stringWithFormat:@"%@v1/%@/?tags=%@&limit=32", apiUrl, resourceMapping[[Post clsName]], @13529]];

    XCTAssertNotNil(posts, @"Failed to load posts for tag");

    NSArray* arrayOfPosts = [self parseObjectsFromList:posts[@"results"] withType:[Post clsName]];

    XCTAssertNotEqual(arrayOfPosts.count, 0, @"It's empty");
}

- (void)testLoadPostsForCategory {
    id posts = [self jsonResponseFromUrl:[NSString stringWithFormat:@"%@v1/%@/?categories=%@&limit=32", apiUrl, resourceMapping[[PostCategory clsName]], @50]];

    XCTAssertNotNil(posts, @"Failed to load posts for category");

    NSArray* arrayOfPosts = [self parseObjectsFromList:posts[@"results"] withType:[Post clsName]];

    XCTAssertNotEqual(arrayOfPosts.count, 0, @"It's empty");
}

@end
