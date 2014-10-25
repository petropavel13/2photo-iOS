//
//  NSObject+Extensions.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "NSObject+Extensions.h"
#import <objc/runtime.h>

@implementation NSObject (Extensions)

static NSString * const userInfoDataKey = @"user_info_data";

+ (NSString*)clsName {
    return NSStringFromClass(self);
}

- (instancetype)nilIfNull {
    return [[NSNull null] isEqual:self] ? nil : self;
}

- (instancetype)nullIfNil {
    return self == nil ? [NSNull null] : self;
}

- (instancetype)operation:(void (^)(id))block {
    block(self);

    return self;
}

- (void)setUserInfoData:(id)userInfoData {
    objc_setAssociatedObject(self, &userInfoDataKey, userInfoData, OBJC_ASSOCIATION_RETAIN);
}

- (id)userInfoData {
    return objc_getAssociatedObject(self, &userInfoDataKey);
}

@end
