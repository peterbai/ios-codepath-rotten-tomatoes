//
//  CPMovieDetailViewController.m
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/7/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import "CPMovieDetailViewController.h"
#import "CPErrorView.h"
#import <UIImageView+AFNetworking.h>

@interface CPMovieDetailViewController ()

@property (strong, nonatomic) UIView *backgroundColorView;
@property (strong, nonatomic) UIImageView *movieDetailPosterImageView;
@property (strong, nonatomic) UIScrollView *detailScrollView;
@property (nonatomic) CGFloat scrollAreaHeight;

@property (strong, nonatomic) CPErrorView *errorView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *criticsLabel;
@property (strong, nonatomic) UILabel *audienceLabel;
@property (strong, nonatomic) UILabel *mpaaRatingLabel;
@property (strong, nonatomic) UILabel *runtimeLabel;
@property (strong, nonatomic) UILabel *synopsisLabel;
@property (strong, nonatomic) UIView *detailBackgroundView;

- (void)onScrollViewTapped;

@end

@implementation CPMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat yPositionReference = 399;
    
    // Initialize view
    CGSize viewSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    // NSLog(@"height: %f, width: %f", size.height, size.width);
    
    self.backgroundColorView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundColorView.backgroundColor = [UIColor blackColor];
    
    // Customize UINavigationBar
    [self setTitle:self.titleString];
    
    // Initialize error view
    self.errorView = [[CPErrorView alloc] init];
    self.errorView.finalPositionY = self.navigationController.navigationBar.frame.size.height +
    [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // Initialize movie image view
    self.movieDetailPosterImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.movieDetailPosterImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.movieDetailPosterImageView setClipsToBounds:YES];
    
    NSURL *thumbnailImageUrl = [[NSURL alloc] initWithString:self.thumbnailImageUrlString];
    NSURL *originalImageUrl = [[NSURL alloc] initWithString:self.originalImageUrlString];
    NSURLRequest *originalImageRequest = [NSURLRequest requestWithURL:originalImageUrl];

    __weak UIImageView *weakMovieDetailPosterImageView = self.movieDetailPosterImageView;
    __weak CPMovieDetailViewController *weakSelf = self;
    [self.movieDetailPosterImageView setImageWithURL:thumbnailImageUrl];
    [self.movieDetailPosterImageView setImageWithURLRequest:originalImageRequest
                                           placeholderImage:nil
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                        UIImageView *strongMovieDetailPosterImageView = weakMovieDetailPosterImageView;
                                                        CPMovieDetailViewController *strongSelf = weakSelf;
                                                        
                                                        [strongSelf.errorView dismissError];
                                                        [UIView transitionWithView:strongMovieDetailPosterImageView
                                                                          duration:0.3
                                                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                                                        animations:^{
                                                                            strongMovieDetailPosterImageView.image = image;
                                                                        }
                                                                        completion:nil];
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                        NSLog(@"failed to load original image in detail view: %@", error);
                                                        
                                                        CPMovieDetailViewController *strongSelf = weakSelf;
                                                        [strongSelf.errorView showError];
                                                    }];

    // Initialize title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, yPositionReference + 10, 292, 40)];
    self.titleLabel.text = self.titleString;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    // Initialize critics score
    self.criticsLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, yPositionReference + 46, 292, 20)];
    self.criticsLabel.text = [[@"Critics: " stringByAppendingString:self.criticsScore] stringByAppendingString:@"%"];
    self.criticsLabel.textColor = [UIColor whiteColor];
    self.criticsLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    
    // Initialize audience score
    self.audienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, yPositionReference + 64, 292, 20)];
    self.audienceLabel.text = [[@"Audience: " stringByAppendingString:self.audienceScore] stringByAppendingString:@"%"];
    self.audienceLabel.textColor = [UIColor whiteColor];
    self.audienceLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    
    // Initialize MPAA rating
    self.mpaaRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, yPositionReference + 88, 0, 0)];
    self.mpaaRatingLabel.text = self.mpaaRating;
    self.mpaaRatingLabel.textColor = [UIColor whiteColor];
    self.mpaaRatingLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
    
    self.mpaaRatingLabel.textAlignment = NSTextAlignmentCenter;
    self.mpaaRatingLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mpaaRatingLabel.layer.borderWidth = 1.0;
    self.mpaaRatingLabel.layer.cornerRadius = 4.0;
    [self.mpaaRatingLabel.layer setMasksToBounds:YES];
    
    [self.mpaaRatingLabel sizeToFit];
    CGRect textFrame = self.mpaaRatingLabel.frame;
    textFrame.size.height = 16;
    textFrame.size.width += 8;
    self.mpaaRatingLabel.frame = textFrame;
    
    // Initialize runtime label
    self.runtimeLabel = [[UILabel alloc] init];
    self.runtime = [self.runtime stringByAppendingString:@"m"];
    self.runtimeLabel.text = self.runtime;
    self.runtimeLabel.textColor = [UIColor whiteColor];
    self.runtimeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    
    CGRect runtimeFrame = CGRectMake(self.mpaaRatingLabel.frame.origin.x + self.mpaaRatingLabel.frame.size.width + 6, yPositionReference + 86, 60, 20);
    self.runtimeLabel.frame = runtimeFrame;
    
    // Initialize synopsis label
    CGRect synopsisFrame = CGRectMake(14, yPositionReference + 120, 292, 0);
    self.synopsisLabel = [[UILabel alloc] initWithFrame:synopsisFrame];
    self.synopsisLabel.text = self.synopsisString;
    self.synopsisLabel.textColor = [UIColor whiteColor];
    self.synopsisLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    self.synopsisLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.synopsisLabel.numberOfLines = 0;
    [self.synopsisLabel sizeToFit];
    
    // Initialize detail background view
    self.detailBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, yPositionReference, viewSize.width, self.synopsisLabel.frame.size.height + 800)];
    self.detailBackgroundView.backgroundColor = [UIColor blackColor];
    self.detailBackgroundView.alpha = 0.8;
    
    // Initialize UIScrollView
    self.scrollAreaHeight = self.synopsisLabel.frame.size.height + 600;
    self.detailScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.detailScrollView.contentSize = CGSizeMake(viewSize.width, self.scrollAreaHeight);
    [self.detailScrollView setShowsVerticalScrollIndicator:NO];
    [self.detailScrollView setShowsHorizontalScrollIndicator:NO];
    
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollViewTapped)];
    [self.detailScrollView addGestureRecognizer:tapGestureRecognizer];
    
    // Add subviews
    [self.view addSubview:self.backgroundColorView];
    [self.view addSubview:self.movieDetailPosterImageView];
    [self.view addSubview:self.detailScrollView];
    [self.view addSubview:self.errorView];
    [self.detailScrollView addSubview:self.detailBackgroundView];
    [self.detailScrollView addSubview:self.titleLabel];
    [self.detailScrollView addSubview:self.criticsLabel];
    [self.detailScrollView addSubview:self.audienceLabel];
    [self.detailScrollView addSubview:self.mpaaRatingLabel];
    [self.detailScrollView addSubview:self.runtimeLabel];
    [self.detailScrollView addSubview:self.synopsisLabel];
}

- (void)onScrollViewTapped {
    
//    NSLog(@"tapped the image, scroll area height = %f, scroll offset = %f", self.scrollAreaHeight, self.detailScrollView.contentOffset.y);
//    NSLog(@"ratio: %f", self.detailScrollView.contentOffset.y / self.scrollAreaHeight);

    CGFloat contentOffset = 568;
    
    if (self.detailScrollView.contentOffset.y / self.scrollAreaHeight < 0.1) {
        if (self.scrollAreaHeight - contentOffset > 339) {
            [self.detailScrollView setContentOffset:CGPointMake(0, 339) animated:YES];
        } else {
            [self.detailScrollView setContentOffset:CGPointMake(0, self.scrollAreaHeight - contentOffset) animated:YES];
        }
    } else {
        [self.detailScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)dealloc {
    
    // NSLog(@"deallocating detail view");
    [self.movieDetailPosterImageView cancelImageRequestOperation];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
