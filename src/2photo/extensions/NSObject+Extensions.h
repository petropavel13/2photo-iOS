//
//  NSObject+Extensions.h
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extensions)

+ (NSString*)clsName;

- (instancetype)nilIfNull;

- (instancetype)nullIfNil;

- (instancetype)operation:(void(^)(id))block;

@property (nonatomic, strong) id userInfoData;

@end
