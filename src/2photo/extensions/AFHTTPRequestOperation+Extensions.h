//
//  AFHTTPRequestOperation+Extensions.h
//  2photo
//
//  Created by smolin_in on 20/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface AFHTTPRequestOperation (Extensions)

+ (id)synchroniousRequestJSONFromUrl:(NSString*)url;

@end
