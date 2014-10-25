//
//  Entry.h
//  2photo
//
//  Created by smolin_in on 25/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * bigImageUrl;
@property (nonatomic, retain) NSString * entryDescription;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * mediumImageUrl;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Post *post;

@end
