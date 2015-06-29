//
//  TPAppConstants.m
//  2photo
//
//  Created by smolin_in on 19/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import "TPAppConstants.h"

@implementation TPAppConstants

NSString * const apiUrl = @"http://192.227.236.251/v1/";
//NSString * const apiUrl = @"http://198.49.66.155/v1/";
NSString * const postDetailControllerIdentifier = @"post_detail_controller";
NSString * const authorDetailControllerIdentifier = @"author_detail_controller";
NSString * const artistDetailControllerIdentifier = @"artist_detail_controller";

UIColor * darknessGray;
UIColor * popoverTransparentGray;

UIStoryboard * currentStoryboard = nil;

static NSString * const iPadStoryBoardName = @"iPad_Storyboard";

+ (void)initialize {
    [super initialize];

    currentStoryboard = [UIStoryboard storyboardWithName: UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? iPadStoryBoardName : iPadStoryBoardName bundle:[NSBundle mainBundle]];
    darknessGray = [UIColor colorWithRed:32 / 255.0 green:32 / 255.0 blue:32 / 255.0 alpha:1];
    popoverTransparentGray = [UIColor colorWithRed:32 / 255.0 green:32 / 255.0 blue:32 / 255.0 alpha:0.96];
}

+ (void)staticInit {

}

@end
