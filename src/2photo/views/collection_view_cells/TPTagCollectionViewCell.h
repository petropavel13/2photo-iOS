//
//  TPTagCollectionViewCell.h
//  2photo
//
//  Created by smolin_in on 26/04/14.
//  Copyright (c) 2014 null inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import "PostCategory.h"

@interface TPTagCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Tag* postTag;
@property (nonatomic, strong) PostCategory* postCategory;
@property (nonatomic, readonly) CGSize optimalSize;

@end
