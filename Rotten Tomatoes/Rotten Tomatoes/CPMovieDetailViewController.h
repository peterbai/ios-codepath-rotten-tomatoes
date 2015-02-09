//
//  CPMovieDetailViewController.h
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/7/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMovieDetailViewController : UIViewController

@property (nonatomic, strong) NSString *thumbnailImageUrlString;
@property (nonatomic, strong) NSString *originalImageUrlString;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *criticsScore;
@property (nonatomic, strong) NSString *audienceScore;
@property (nonatomic, strong) NSString *mpaaRating;
@property (nonatomic, strong) NSString *runtime;
@property (nonatomic, strong) NSString *synopsisString;

@end
