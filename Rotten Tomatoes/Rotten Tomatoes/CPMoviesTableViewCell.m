//
//  CPMoviesTableViewCell.m
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/5/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import "CPMoviesTableViewCell.h"

@interface CPMoviesTableViewCell ()

@property (strong, nonatomic) UIView *colorView; // test UIView
@property (strong, nonatomic) UIView *backgroundColorView;
@property (strong, nonatomic) UILabel *movieMpaaRatingLabel;
@property (strong, nonatomic) UILabel *movieRuntimeLabel;

- (void)cellHighlighted;
- (void)cellDeselected;

@end

@implementation CPMoviesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        // Initialize and configure cell
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.alpha = 0;
        CGSize size = CGSizeMake(self.contentView.frame.size.width, 300);
        
        // Initialize background color view
        self.backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.backgroundColorView.backgroundColor = [UIColor blackColor];
        
        // Initialize UIImageView
        self.moviePosterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self.moviePosterImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.moviePosterImageView setClipsToBounds:YES];
        
        // add gradient to UIImageView
        CAGradientLayer *gradientMask = [CAGradientLayer layer];
        gradientMask.frame = self.moviePosterImageView.bounds;
        gradientMask.colors = @[(id)[UIColor whiteColor].CGColor,
                                (id)[UIColor colorWithWhite:0 alpha:0.1].CGColor];
        gradientMask.locations = @[@0.4, @0.8];
        self.moviePosterImageView.layer.mask = gradientMask;
        
        // Initialize labels
            // mpaa rating
        self.movieMpaaRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 186, 0, 0)];
        self.movieMpaaRatingLabel.textColor = [UIColor whiteColor];
        self.movieMpaaRatingLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];

        self.movieMpaaRatingLabel.textAlignment = NSTextAlignmentCenter;
        self.movieMpaaRatingLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.movieMpaaRatingLabel.layer.borderWidth = 1.0;
        self.movieMpaaRatingLabel.layer.cornerRadius = 4.0;
        [self.movieMpaaRatingLabel.layer setMasksToBounds:YES];
        
            // runtime
        CGRect runtimeFrame = CGRectMake(self.movieMpaaRatingLabel.frame.origin.x + self.movieMpaaRatingLabel.frame.size.width + 4, 182, 60, 30);
        self.movieRuntimeLabel = [[UILabel alloc] initWithFrame:runtimeFrame];
        self.movieRuntimeLabel.textColor = [UIColor whiteColor];
        self.movieRuntimeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
        self.movieRuntimeLabel.adjustsFontSizeToFitWidth = YES;
 
            // title
        self.movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 240, 50)];
        self.movieTitleLabel.text = @"Test Movie";
        self.movieTitleLabel.textColor = [UIColor whiteColor];
        self.movieTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:32];
        self.movieTitleLabel.adjustsFontSizeToFitWidth = YES;
        
            // synopsis
        self.movieSynopsisLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 50)];
        self.movieSynopsisLabel.textColor = [UIColor whiteColor];
        self.movieSynopsisLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        self.movieSynopsisLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.movieSynopsisLabel.numberOfLines = 2;
        
        /*
         UILabel *movieCriticsRatingLabel;
         */
        
        // Add views to contentView
        [self.contentView addSubview:self.backgroundColorView];
        [self.contentView addSubview:self.moviePosterImageView];
        [self.contentView addSubview:self.movieMpaaRatingLabel];
        [self.contentView addSubview:self.movieRuntimeLabel];
        [self.contentView addSubview:self.movieTitleLabel];
        [self.contentView addSubview:self.movieSynopsisLabel];
        
        // Animate labels
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.contentView.alpha = 1.0;
                         }];


    }
    return self;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    // remove image prior to reuse to avoid seeing old image
    [self.moviePosterImageView cancelImageRequestOperation];
    self.moviePosterImageView.image = nil;
}

# pragma mark Selection and Highlight Methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    if (highlighted) {
        
        [self cellHighlighted];
        
    } else {
        
        [self cellDeselected];
    }
}

- (void)cellHighlighted {
    
    UIColor *highlightedColor = [UIColor colorWithRed:122.0 / 255
                                               green:197.0 / 255
                                                blue:255.0 / 255
                                               alpha:1.0];
    
    [UIView transitionWithView:self.movieMpaaRatingLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.movieMpaaRatingLabel.textColor = highlightedColor;
        self.movieMpaaRatingLabel.layer.borderColor = highlightedColor.CGColor;
    } completion:^(BOOL finished) {
    }];
    
    [UIView transitionWithView:self.movieRuntimeLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.movieRuntimeLabel.textColor = highlightedColor;
    } completion:^(BOOL finished) {
    }];
    
    [UIView transitionWithView:self.movieTitleLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.movieTitleLabel.textColor = highlightedColor;
    } completion:^(BOOL finished) {
    }];
    
    [UIView transitionWithView:self.movieSynopsisLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.movieSynopsisLabel.textColor = highlightedColor;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.moviePosterImageView.alpha = 0.5;
    }];
}

- (void)cellDeselected {
    
    UIColor *defaultColor = [UIColor whiteColor];
    
    [UIView transitionWithView:self.movieMpaaRatingLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.movieMpaaRatingLabel.textColor = defaultColor;
        self.movieMpaaRatingLabel.layer.borderColor = defaultColor.CGColor;
    } completion:^(BOOL finished) {
    }];
    
    [UIView transitionWithView:self.movieRuntimeLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.movieRuntimeLabel.textColor = defaultColor;
    } completion:^(BOOL finished) {
    }];
    
    [UIView transitionWithView:self.movieTitleLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.movieTitleLabel.textColor = defaultColor;
    } completion:^(BOOL finished) {
    }];
    
    [UIView transitionWithView:self.movieSynopsisLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.movieSynopsisLabel.textColor = defaultColor;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.moviePosterImageView.alpha = 1.0;
    }];
}

# pragma mark Custom Setters

- (void)setMpaaRating:(NSString *)rating {
    
    self.movieMpaaRatingLabel.text = rating;
    
    [self.movieMpaaRatingLabel sizeToFit];
    CGRect textFrame = self.movieMpaaRatingLabel.frame;
    textFrame.size.height = 18;
    textFrame.size.width += 10;
    self.movieMpaaRatingLabel.frame = textFrame;
    
}

- (void)setRuntime:(NSString *)runtime {
    
    runtime = [runtime stringByAppendingString:@"m"];
    self.movieRuntimeLabel.text = runtime;
    CGRect runtimeFrame = CGRectMake(self.movieMpaaRatingLabel.frame.origin.x + self.movieMpaaRatingLabel.frame.size.width + 4, 182, 60, 30);
    self.movieRuntimeLabel.frame = runtimeFrame;
    
}

@end
