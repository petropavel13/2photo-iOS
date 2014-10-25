//
//  TPParserProtocol.h
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TPParserProtocol <NSObject>

+ (instancetype)objectWithId:(NSNumber*)objId;
+ (instancetype)objectFromJSON:(id)JSON;
+ (instancetype)detailObjectFromJSON:(id)JSON;

@end
