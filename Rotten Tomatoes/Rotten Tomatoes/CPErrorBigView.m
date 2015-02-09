//
//  CPErrorBigView.m
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/8/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import "CPErrorBigView.h"
#import <NSString+FontAwesome.h>

@interface CPErrorBigView ()

@property (strong, nonatomic) UILabel *errorIconLabel;

@end

@implementation CPErrorBigView

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 300);
        self.hidden = YES;
        
        // Initialize error icon label
        self.errorIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
        self.errorIconLabel.text = [NSString awesomeIcon:FaChainBroken];
        self.errorIconLabel.textColor = [UIColor clearColor];
        self.errorIconLabel.textAlignment = NSTextAlignmentCenter;
        self.errorIconLabel.font = [UIFont fontWithName:@"FontAwesome" size:80];
        
        [self addSubview:self.errorIconLabel];
    }
    return self;
}

- (void)showError {
    
    self.hidden = NO;
    [UIView transitionWithView:self.errorIconLabel duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.errorIconLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    } completion:^(BOOL finished) {
    }];

}

- (void)dismissError{
    
    [UIView transitionWithView:self.errorIconLabel duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.errorIconLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
