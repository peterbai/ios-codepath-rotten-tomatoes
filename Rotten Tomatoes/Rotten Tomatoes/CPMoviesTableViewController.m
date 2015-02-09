//
//  CPMoviesTableViewController.m
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/5/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import "CPMoviesTableViewController.h"
#import "CPMoviesTableViewCell.h"
#import "CPMoviesCollectionViewCell.h"
#import "CPMovieDetailViewController.h"
#import "CPErrorView.h"
#import "CPErrorBigView.h"
#import "CPRefreshControl.h"
#import "CPSearchAndLayoutView.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>

@interface CPMoviesTableViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *responseDictionary;
@property (strong, nonatomic) NSArray *responseMoviesArray;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) CPErrorView *errorView;
@property (strong, nonatomic) CPErrorBigView *errorBigView;
@property (strong, nonatomic) CPRefreshControl *refreshControl;
@property (strong, nonatomic) CPSearchAndLayoutView *searchAndLayoutView;
@property (strong, nonatomic) UITapGestureRecognizer *navBarTapRecognizer;
@property (nonatomic) BOOL makingFirstNetworkRequest;
@property (nonatomic) BOOL isFiltered;
@property (nonatomic) CGFloat yPositionBelowNavBar;
@property (nonatomic) CGFloat yPositionSearchBarHidden;

@property (strong, nonatomic) UICollectionView *collectionView;

- (void)getMoviesList:(BOOL)firstRequest;
- (void)onRefresh;
- (void)navBarTapped;

@end

@implementation CPMoviesTableViewController

# pragma mark View Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set status bar to light
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // Initialize position variables
    self.yPositionBelowNavBar = self.navigationController.navigationBar.frame.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
    
    
    // Customize navigation bar
    self.navigationController.navigationBar.titleTextAttributes =
        @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    // Initialize and configure UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 300;
    self.tableView.backgroundColor = [UIColor colorWithRed:32.0 / 255
                                                     green:44.0 / 255
                                                      blue:54.0 / 255
                                                     alpha:1.0];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
        // register the UITableViewCells
    [self.tableView registerClass:[CPMoviesTableViewCell class] forCellReuseIdentifier:@"moviesTableViewCell"];
    
    // Initialize refresh control
    self.refreshControl = [[CPRefreshControl alloc] initInScrollView:self.tableView];
    self.refreshControl.assignedPositionY = self.yPositionBelowNavBar;
    [self.refreshControl addTarget:self
                            action:@selector(onRefresh)
                  forControlEvents:UIControlEventValueChanged];
    
    // Initialize search and layout view
    self.searchAndLayoutView = [[CPSearchAndLayoutView alloc] init];
    self.searchAndLayoutView.hidden = YES;  // hide until we've loaded data
    self.searchAndLayoutView.searchBar.delegate = (id)self;
    
    self.yPositionSearchBarHidden = self.yPositionBelowNavBar - self.searchAndLayoutView.frame.size.height;
    
    // Initialize error view
    self.errorView = [[CPErrorView alloc] init];
    self.errorView.finalPositionY = self.yPositionBelowNavBar;
    
    // Initialize large error view
    self.errorBigView = [[CPErrorBigView alloc] init];
    
    // Initialize collectionView
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                             collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[CPMoviesCollectionViewCell class] forCellWithReuseIdentifier:@"moviesCollectionViewCell"];
    
    // Add subviews to view
    [self.view addSubview:self.tableView];
    // [self.view addSubview:self.collectionView];
    
    self.tableView.tableHeaderView = self.searchAndLayoutView;
    [self.view addSubview:self.errorView];
    [self.tableView addSubview:self.errorBigView];
    
    // Make the network request
    [self getMoviesList:YES];
    self.makingFirstNetworkRequest = YES;
}

- (void)viewWillAppear:(BOOL)animated {
 
    // Animate status bar to light
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
 
    // Set up navigation bar gesture recognizer
    self.navBarTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navBarTapped)];
    [self.navigationController.navigationBar addGestureRecognizer:self.navBarTapRecognizer];
    
    if (self.makingFirstNetworkRequest) {
        self.makingFirstNetworkRequest = NO;
        return;
    } else {
        [self getMoviesList:NO];
    }
}

- (void)viewWillLayoutSubviews {

//        self.tableView.contentOffset = CGPointMake(0, -self.yPositionSearchBarHidden);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // Remove navigation bar gesture recognizer
    [self.navigationController.navigationBar removeGestureRecognizer:self.navBarTapRecognizer];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.errorView dismissError];
}

# pragma mark Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *moviesArray;
    if (self.isFiltered) {
        moviesArray = self.searchResults;
    } else {
        moviesArray = self.responseMoviesArray;
    }
    
    return [moviesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *moviesArray;
    if (self.isFiltered) {
        moviesArray = self.searchResults;
    } else {
        moviesArray = self.responseMoviesArray;
    }
    
    CPMoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moviesTableViewCell"];

    // Set title
    cell.movieTitleLabel.text = [moviesArray[indexPath.row] objectForKey:@"title"];

    // Set image
    NSString *thumbnailImageUrlString = [moviesArray[indexPath.row] objectForKey:@"posters"][@"thumbnail"];
    NSString *originalImageUrlString = [thumbnailImageUrlString stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_ori.jpg"];
    NSURL *thumbnailImageUrl = [[NSURL alloc] initWithString:thumbnailImageUrlString];
    NSURL *originalImageUrl = [[NSURL alloc] initWithString:originalImageUrlString];

    NSURLRequest *thumbnailImageRequest = [NSURLRequest requestWithURL:thumbnailImageUrl];
    NSURLRequest *originalImageRequest = [NSURLRequest requestWithURL:originalImageUrl];

    __weak CPMoviesTableViewCell *weakCell = cell;
    [cell.moviePosterImageView setImageWithURLRequest:thumbnailImageRequest
                                     placeholderImage:nil
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  CPMoviesTableViewCell *strongCell = weakCell;
                                                  
                                                  [UIView transitionWithView:strongCell.moviePosterImageView
                                                                    duration:0.3
                                                                     options:UIViewAnimationOptionTransitionCrossDissolve
                                                                  animations:^{
                                                                      strongCell.moviePosterImageView.image = image;
                                                                  }
                                                                  completion:nil];
                                                  [strongCell.moviePosterImageView setImageWithURLRequest:originalImageRequest
                                                                                       placeholderImage:nil
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                    CPMoviesTableViewCell *innerStrongCell = weakCell;
                                                                                                    [UIView transitionWithView:innerStrongCell.moviePosterImageView
                                                                                                                      duration:0.3
                                                                                                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                                                                                                    animations:^{
                                                                                                                        innerStrongCell.moviePosterImageView.image = image;
                                                                                                                    }
                                                                                                                    completion:nil];
                                                                                                }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                    NSLog(@"Error retrieving orignal image: %@", error);
                                                                                                }];
                                              }
                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"Error retriving thumbnail image: %@", error);
                                              }];
    
    // Set MPAA rating
    [cell setMpaaRating:[moviesArray[indexPath.row] objectForKey:@"mpaa_rating"]];
    
    // Set runtime
    [cell setRuntime:[[moviesArray[indexPath.row] objectForKey:@"runtime"] stringValue]];
    
    // Set synopsis
    cell.movieSynopsisLabel.text = [moviesArray[indexPath.row] objectForKey:@"synopsis"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *moviesArray;
    if (self.isFiltered) {
        moviesArray = self.searchResults;
    } else {
        moviesArray = self.responseMoviesArray;
    }
    
    CPMovieDetailViewController *movieDetailViewController = [[CPMovieDetailViewController alloc] init];

    NSString *thumbnailImageUrlString = [moviesArray[indexPath.row] objectForKey:@"posters"][@"thumbnail"];
    NSString *originalImageUrlString = [thumbnailImageUrlString stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_ori.jpg"];
    
    movieDetailViewController.thumbnailImageUrlString = thumbnailImageUrlString;
    movieDetailViewController.originalImageUrlString = originalImageUrlString;
    movieDetailViewController.titleString = [moviesArray[indexPath.row] objectForKey:@"title"];
    movieDetailViewController.criticsScore = [[moviesArray[indexPath.row] objectForKey:@"ratings"][@"critics_score"] stringValue];
    movieDetailViewController.audienceScore = [[moviesArray[indexPath.row] objectForKey:@"ratings"][@"audience_score"] stringValue];
    movieDetailViewController.mpaaRating = [moviesArray[indexPath.row] objectForKey:@"mpaa_rating"];
    movieDetailViewController.runtime = [[moviesArray[indexPath.row] objectForKey:@"runtime"] stringValue];
    movieDetailViewController.synopsisString = [moviesArray[indexPath.row] objectForKey:@"synopsis"];
    
    [self.searchAndLayoutView.searchBar resignFirstResponder];
    
    [self.navigationController pushViewController:movieDetailViewController animated:YES];
}

/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
//    *targetContentOffset = CGPointMake(0, targetContentOffset->y);
    NSLog(@"You will arrive at y position: %f", targetContentOffset->y);
    
    if (targetContentOffset->y < -38) {  // search bar is barely peeking from top
        [self.tableView setContentOffset:CGPointMake(0, -self.yPositionBelowNavBar) animated:YES];
        
    } else if (targetContentOffset->y < -5) {
        [self.tableView setContentOffset:CGPointMake(0, -self.yPositionSearchBarHidden) animated:YES];
    }
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"Y offset is now: %f", scrollView.contentOffset.y);
}

# pragma mark Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSArray *moviesArray;
    if (self.isFiltered) {
        moviesArray = self.searchResults;
    } else {
        moviesArray = self.responseMoviesArray;
    }
    
    NSLog(@"count of collection items: %d", [moviesArray count]);
    return [moviesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *moviesArray;
    if (self.isFiltered) {
        moviesArray = self.searchResults;
    } else {
        moviesArray = self.responseMoviesArray;
    }
    
    CPMoviesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moviesCollectionViewCell"
                                                                                 forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(159, 159);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

# pragma mark Network Methods

- (void)getMoviesList:(BOOL)firstRequest {

    if (firstRequest) {
        [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
        [SVProgressHUD setRingThickness:4];
        [SVProgressHUD show];
    }
    
    NSURL *url = [NSURL URLWithString:self.rottenTomatoesURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (firstRequest) {
            self.tableView.contentOffset = CGPointMake(0, -self.yPositionSearchBarHidden);
        }
        self.responseDictionary = responseObject;
        self.responseMoviesArray = [responseObject objectForKey:@"movies"];
        // NSLog(@"%@", self.responseMoviesArray);
        self.searchAndLayoutView.hidden = NO;
        [self.tableView reloadData];
        [self.collectionView reloadData];
        
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        [self.errorView dismissError];
        [self.errorBigView dismissError];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Get movies API request failed with error: %@", error);
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        [self.errorView showError];
        
        if (firstRequest) {
            [self.errorBigView showError];
        }
    }];
    
    [operation start];
}

- (void)onRefresh {
    
    [self getMoviesList:NO];
}

# pragma mark Search Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"began editing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        
        self.isFiltered = NO;
        
    } else {
        
        self.isFiltered = YES;

        NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
        self.searchResults = [self.responseMoviesArray filteredArrayUsingPredicate:resultsPredicate];
    }
    
    [self.tableView reloadData];
}

#pragma mark Gesture Methods

- (void)navBarTapped {
    [self.searchAndLayoutView.searchBar resignFirstResponder];
}

# pragma mark System Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
