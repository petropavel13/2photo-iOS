//
//  TPObjectSelectedDelegate.h
//  2photo
//
//  Created by smolin_in on 03/05/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TPObjectSelectedDelegate <NSObject>

- (void)objectSelected:(id)object inController:(id)controller;

@end
