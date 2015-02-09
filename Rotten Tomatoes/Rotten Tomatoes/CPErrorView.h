//
//  CPErrorView.h
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/8/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPErrorView : UIView

@property (nonatomic) CGFloat finalPositionY;

- (void)showError;
- (void)dismissError;

@end
