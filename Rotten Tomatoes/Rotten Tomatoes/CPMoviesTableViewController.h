//
//  CPMoviesTableViewController.h
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/5/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMoviesTableViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSString *rottenTomatoesURLString;

@end
