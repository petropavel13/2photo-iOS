//
//  NSManagedObject+Extensions.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "NSManagedObject+Extensions.h"
#import "NSObject+Extensions.h"

@implementation NSManagedObject (Extensions)

+ (instancetype)managedObjectWithContext:(NSManagedObjectContext*)ctx {
    return [[self alloc] initWithEntity:[NSEntityDescription entityForName:[self clsName] inManagedObjectContext:ctx] insertIntoManagedObjectContext:nil];
}

+ (instancetype)managedObjectInsertedInContext:(NSManagedObjectContext*)ctx {
    return [[self alloc] initWithEntity:[NSEntityDescription entityForName:[self clsName] inManagedObjectContext:ctx] insertIntoManagedObjectContext:ctx];
}

@end
