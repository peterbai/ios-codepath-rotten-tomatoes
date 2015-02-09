//
//  CPSearchAndLayoutView.m
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/8/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import "CPSearchAndLayoutView.h"

@interface CPSearchAndLayoutView ()

@end

@implementation CPSearchAndLayoutView

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        // Initialize view properties
        CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
        
        self.frame = CGRectMake(0, 0, mainScreenWidth, 40);
        self.backgroundColor = [UIColor clearColor];
        
        // Initialize search bar
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(2, 6, 232, 28)];
        self.searchBar.placeholder = @"Search";
        self.searchBar.backgroundImage = [UIImage new];
//        self.searchBar.tintColor = [UIColor redColor];  // cursor color
        
        // Customize search bar textfield
        for (UIView *subView in _searchBar.subviews) {
            for(id field in subView.subviews){
                if ([field isKindOfClass:[UITextField class]]) {
                    UITextField *textField = (UITextField *)field;
                    [textField setBackgroundColor:[UIColor colorWithRed:48.0 / 255
                                                                  green:66.0 / 255
                                                                   blue:80.0 / 255
                                                                  alpha:1.0]];
                    [textField setTextColor:[UIColor whiteColor]];
                }
            }
        }
        [self addSubview:self.searchBar];
        
        // Initialize segemented control
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"List", @"Grid"]];
        self.segmentedControl.frame = CGRectMake(234, 6, 80, 28);
        self.segmentedControl.tintColor = [UIColor colorWithRed:72.0 / 255
                                                          green:99.0 / 255
                                                           blue:120.0 / 255
                                                          alpha:1.0];
        
        NSDictionary *segmentedTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                               forKey:NSForegroundColorAttributeName];
        [self.segmentedControl setTitleTextAttributes:segmentedTextAttributes forState:UIControlStateNormal];
        [self.segmentedControl setTitleTextAttributes:segmentedTextAttributes forState:UIControlStateSelected];
        self.segmentedControl.selectedSegmentIndex = 0;
        
        [self addSubview:self.segmentedControl];
        
    }
    return self;
}

@end
