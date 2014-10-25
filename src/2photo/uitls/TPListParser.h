//
//  TPListParser.h
//  2photo
//
//  Created by smolin_in on 30/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPListParser : NSObject

+ (NSArray*)parseJSONObjects:(NSArray*)objects ofType:(Class)cls;

@end
