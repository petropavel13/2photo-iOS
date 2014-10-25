//
//  NSManagedObject+Extensions.h
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Extensions)

+ (instancetype)managedObjectWithContext:(NSManagedObjectContext*)ctx;
+ (instancetype)managedObjectInsertedInContext:(NSManagedObjectContext*)ctx;

@end
