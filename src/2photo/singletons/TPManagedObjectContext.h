//
//  TPManagedObjectContext.h
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TPManagedObjectContext : NSManagedObjectContext

+ (void)staticInit;

+ (instancetype)sharedContext;

- (NSArray*)executeFetchRequest:(NSFetchRequest*)req;

@end
