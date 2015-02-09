//
//  CPRefreshControl.h
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/8/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import "ODRefreshControl.h"

@interface CPRefreshControl : ODRefreshControl

@property (nonatomic, strong) UIScrollView *assignedScrollView;
@property (nonatomic) CGFloat assignedPositionY;

@end
