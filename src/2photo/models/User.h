//
//  User.h
//  2photo
//
//  Created by smolin_in on 17/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Post;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatarUrl;
@property (nonatomic, retain) NSNumber * carma;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * lastVisit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numberOfComments;
@property (nonatomic, retain) NSNumber * numberOfPosts;
@property (nonatomic, retain) NSDate * registrationDate;
@property (nonatomic, retain) NSString * site;
@property (nonatomic, retain) NSString * userDescription;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *posts;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
