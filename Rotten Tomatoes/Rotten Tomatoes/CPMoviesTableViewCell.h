//
//  CPMoviesTableViewCell.h
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/5/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface CPMoviesTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *moviePosterImageView;
@property (strong, nonatomic) UIImageView *movieCriticsRatingImage;
@property (strong, nonatomic) UILabel *movieTitleLabel;
@property (strong, nonatomic) UILabel *movieSynopsisLabel;
@property (strong, nonatomic) UILabel *movieCriticsRatingLabel;

- (void)setMpaaRating:(NSString *)rating;
- (void)setRuntime:(NSString *)runtime;

@end
