//
//  TPInfiniteLoader.h
//  2photo
//
//  Created by smolin_in on 30/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPInfiniteLoader;

@protocol TPInfiniteLoaderDelegate <NSObject>

- (void)infiniteLoader:(TPInfiniteLoader*)loader didFinishedLoading:(NSArray*)objects;

@end

@interface TPInfiniteLoader : NSObject

@property (nonatomic, weak) id<TPInfiniteLoaderDelegate> delegate;
@property (nonatomic, readonly) Class objectsClass;
@property (nonatomic, readonly) BOOL isLoadingFinished;

+ (instancetype)loaderWithClass:(Class)cls andFilterParams:(NSDictionary*)filterParams;
+ (instancetype)loaderWithClass:(Class)cls filterParams:(NSDictionary*)filterParams andDelegate:(id<TPInfiniteLoaderDelegate>)delegate;

- (void)loadMore;

@end
