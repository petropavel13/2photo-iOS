//
//  TPManagedObjectContext.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPManagedObjectContext.h"

static TPManagedObjectContext* instance = nil;

@implementation TPManagedObjectContext

+ (void)staticInit {
    instance = [[TPManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

    NSManagedObjectModel* model = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];

    NSPersistentStoreCoordinator* coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSError* error = nil;
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];

    if (error != nil) {
        // TODO report

        NSLog(@"Error when addPersistentStoreWithType. Error: %@", error);
    }

    [instance setPersistentStoreCoordinator:coordinator];
}

+ (instancetype)sharedContext {
//    @synchronized(self) {
//        if (instance == nil) {
//
//        }
//    }

    return instance;
}

- (NSArray *)executeFetchRequest:(NSFetchRequest *)req {
    NSError* error = nil;

    NSArray* res = [self executeFetchRequest:req error:&error];

    if (error != nil) {
        // TODO report

        NSLog(@"Error when execute fetch request. Error: %@", error);
    }

    return res;
}

@end
