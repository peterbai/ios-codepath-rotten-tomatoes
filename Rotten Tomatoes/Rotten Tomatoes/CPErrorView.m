//
//  CPErrorView.m
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/8/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import "CPErrorView.h"
#import <NSString+FontAwesome.h>

@interface CPErrorView ()

@property (strong, nonatomic) UILabel *errorTextLabel;
@property (strong, nonatomic) UILabel *errorIconLabel;
@property (nonatomic) BOOL isErrorState;

@end

@implementation CPErrorView


- (instancetype)init {

    self = [super init];
    
    if (self) {
        self.isErrorState = NO;
        self.backgroundColor = [UIColor colorWithRed:32.0 / 255
                                               green:44.0 / 255
                                                blue:54.0 / 255
                                               alpha:1.0];
        self.hidden = YES;
        self.alpha = 0;
        
        // Initialize error text label
        self.errorTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 4, 100, 14)];
        self.errorTextLabel.text = @"Network Error";
        self.errorTextLabel.textColor = [UIColor whiteColor];
        self.errorTextLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        
        [self addSubview:self.errorTextLabel];
        
        // Initialize error icon label
        self.errorIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 4, 20, 14)];
        self.errorIconLabel.text = [NSString awesomeIcon:FaExfclamationTriangle];
        self.errorIconLabel.textColor = [UIColor whiteColor];
        self.errorIconLabel.font = [UIFont fontWithName:@"FontAwesome" size:12];
        
        [self addSubview:self.errorIconLabel];
        
    }
    return self;
}

- (void)showError {
    
    NSLog(@"showError called, errorState: %hhd", self.isErrorState);
    
    CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat animationDistanceY = 20;
    
    if (!self.isErrorState) {
        CGRect startFrame = CGRectMake(0, self.finalPositionY - animationDistanceY, mainScreenWidth, 20);
        CGRect endFrame = CGRectMake(0, self.finalPositionY, mainScreenWidth, 20);
        
        self.frame = startFrame;
        self.hidden = NO;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 0.7;
                             self.frame = endFrame;
                         }];
        
        self.isErrorState = YES;
        
    } else {  // already in error state, just wiggle the text
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position.x";
        animation.values = @[ @0, @8, @-8, @4, @0 ];
        animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
        animation.duration = 0.4;
        animation.additive = YES;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        [self.errorTextLabel.layer addAnimation:animation forKey:@"wiggle"];
        [self.errorIconLabel.layer addAnimation:animation forKey:@"wiggle"];
    }
    
}

- (void)dismissError {
    
    self.isErrorState = NO;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         self.hidden = YES;
                     }];
}

@end
