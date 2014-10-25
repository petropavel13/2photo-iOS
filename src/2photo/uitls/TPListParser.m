//
//  TPListParser.m
//  2photo
//
//  Created by smolin_in on 30/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPListParser.h"
#import "TPParserProtocol.h"

@implementation TPListParser

+ (NSArray *)parseJSONObjects:(NSArray *)objects ofType:(Class)cls {
    const SEL typeParserMethod = @selector(objectFromJSON:);
    NSInvocationOperation* tempOperation = nil;

    NSMutableArray* mutableObjects = [NSMutableArray arrayWithCapacity:objects.count];

    NSMutableArray* operations = [NSMutableArray arrayWithCapacity:objects.count];

    for (id JSONObj in objects) {
        tempOperation = [[NSInvocationOperation alloc] initWithTarget:cls selector:typeParserMethod object:JSONObj];
        [operations addObject:tempOperation];
    }

    NSOperationQueue* queue = [NSOperationQueue new];
    [queue addOperations:operations waitUntilFinished:YES];

    for (NSInvocationOperation* op in operations) {
        [mutableObjects addObject:op.result];
    }

    return [mutableObjects copy];
}

@end
