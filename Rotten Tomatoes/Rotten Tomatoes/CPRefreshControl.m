//
//  CPRefreshControl.m
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/8/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import "CPRefreshControl.h"

@implementation CPRefreshControl

- (id)initInScrollView:(UIScrollView *)scrollView {
    self = [super initInScrollView:scrollView];

    if (self) {
        self.assignedScrollView = scrollView;
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat verticalOffset = -(400 + self.assignedScrollView.contentInset.top) + self.assignedPositionY;

    self.frame = CGRectMake(0, verticalOffset, mainScreenWidth, 400);
}

@end
