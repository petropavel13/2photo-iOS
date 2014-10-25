//
//  NSDate+Parser.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "NSDate+Parser.h"

@implementation NSDate (Parser)

static NSDateFormatter * dateTimeFormatter = nil;
static NSDateFormatter * dateFormatter = nil;

+ (void)staticInit {
    dateTimeFormatter = [NSDateFormatter new];
//    dateTimeFormatter.dateStyle = NSDateFormatterLongStyle;
//    dateTimeFormatter.timeStyle = NSDateFormatterShortStyle;
    dateTimeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";

    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
}

+ (instancetype)dateFromString:(NSString *)date {
    return [dateFormatter dateFromString:date];
}

+ (instancetype)dateTimeFromString:(NSString*)date {
    return [dateTimeFormatter dateFromString:date];
}

@end
