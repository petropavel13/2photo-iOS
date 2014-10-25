//
//  NSDate+Parser.h
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Parser)

+ (void)staticInit;

+ (instancetype)dateFromString:(NSString*)date;
+ (instancetype)dateTimeFromString:(NSString*)date;

@end
