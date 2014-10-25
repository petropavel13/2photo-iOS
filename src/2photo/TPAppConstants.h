//
//  TPAppConstants.h
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const apiUrl;
extern NSString * const postDetailControllerIdentifier;
extern NSString * const authorDetailControllerIdentifier;
extern NSString * const artistDetailControllerIdentifier;

extern UIColor * darknessGray;
extern UIColor * popoverTransparentGray;

extern UIStoryboard * currentStoryboard;

@interface TPAppConstants : NSObject

+ (void)staticInit;

@end
