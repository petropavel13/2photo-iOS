//
//  TPInfiniteLoader.m
//  2photo
//
//  Created by smolin_in on 30/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPInfiniteLoader.h"
#import <AFHTTPRequestOperationManager.h>
#import "TPAppConstants.h"
#import "TPRestMapping.h"
#import "TPListParser.h"

@interface TPInfiniteLoader () {
    NSString* url;
    NSMutableDictionary* params;
    AFHTTPRequestOperation* request;
}

- (instancetype)initWithClass:(Class)cls filterParams:(NSDictionary*)filterParams andDelegate:(id<TPInfiniteLoaderDelegate>)delegate;
- (void)updateRequest;

@end

@implementation TPInfiniteLoader

+ (instancetype)loaderWithClass:(Class)cls andFilterParams:(NSDictionary*)filterParams {
    return [[self alloc] initWithClass:cls filterParams:filterParams andDelegate:nil];
}

+ (instancetype)loaderWithClass:(Class)cls filterParams:(NSDictionary*)filterParams andDelegate:(id<TPInfiniteLoaderDelegate>)delegate {
    TPInfiniteLoader* me = [self loaderWithClass:cls andFilterParams:filterParams];
    me.delegate = delegate;
    return me;
}

- (instancetype)initWithClass:(Class)cls filterParams:(NSDictionary *)filterParams andDelegate:(id<TPInfiniteLoaderDelegate>)delegate {
    if (self = [super init]) {
        _objectsClass = cls;
        url = [apiUrl stringByAppendingString:[[TPRestMapping resourceNameForClass:cls] stringByAppendingString:@"/"]];
        params = filterParams == nil ? [@{@"limit": @32} mutableCopy] : [filterParams mutableCopy];
        _isLoadingFinished = YES;
    }

    return self;
}

- (void)updateRequest {
    request = [[AFHTTPRequestOperationManager manager] GET:url
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       url = responseObject[@"next"];
                                                       params = nil;

                                                       NSArray* objects = responseObject[@"results"];
                                                       [self.delegate infiniteLoader:self didFinishedLoading:[TPListParser parseJSONObjects:objects ofType:_objectsClass]];
                                                       _isLoadingFinished = YES;
                                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       [self loadMore];
                                                   }];

    request.responseSerializer = [AFJSONResponseSerializer serializer];
}

- (void)loadMore {
    if (request.isExecuting || _isLoadingFinished == NO) {
        return;
    } else if ([[NSNull null] isEqual:url]) { // no next page
        _isLoadingFinished = YES;
        [self.delegate infiniteLoader:self didFinishedLoading:@[]];
    } else {
        _isLoadingFinished = NO;
        [self updateRequest];
        [request start];
    }
}

@end
