//
//  AFHTTPRequestOperation+Extensions.m
//  2photo
//
//  Created by smolin_in on 20/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "AFHTTPRequestOperation+Extensions.h"

@implementation AFHTTPRequestOperation (Extensions)

+ (id)synchroniousRequestJSONFromUrl:(NSString*)url {
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation start];
    [operation waitUntilFinished];

    return operation.responseObject;
}

@end
