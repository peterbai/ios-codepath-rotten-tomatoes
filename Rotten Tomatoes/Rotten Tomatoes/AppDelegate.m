//
//  AppDelegate.m
//  Rotten Tomatoes
//
//  Created by Peter Bai on 2/2/15.
//  Copyright (c) 2015 Peter Bai. All rights reserved.
//

#import "AppDelegate.h"
#import "CPMoviesTableViewController.h"
#import "CPDvdsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    
    CPMoviesTableViewController *moviesViewController = [[CPMoviesTableViewController alloc] init];
    moviesViewController.rottenTomatoesURLString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=axy8mmq84ywaymxruppsmj66";
    moviesViewController.title = @"Movies";
    moviesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Movies"
                                                                    image:[UIImage imageNamed:@"movie.png"]
                                                            selectedImage:nil];
    
    CPMoviesTableViewController *dvdsViewController = [[CPMoviesTableViewController alloc] init];
    dvdsViewController.rottenTomatoesURLString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=axy8mmq84ywaymxruppsmj66";
    dvdsViewController.title = @"DVD Rentals";
    dvdsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"DVDs"
                                                                  image:[UIImage imageNamed:@"dvd.png"]
                                                          selectedImage:nil];
    
    // Initialize navigation view controllers
    UINavigationController *moviesNavigationViewController = [[UINavigationController alloc] initWithRootViewController:moviesViewController];
    moviesNavigationViewController.navigationBar.barTintColor = [UIColor colorWithRed:50.0 / 255
                                                                          green:68.0 / 255
                                                                           blue:83.0 / 255
                                                                          alpha:1.0];
    moviesNavigationViewController.navigationBar.tintColor = [UIColor whiteColor];
    
    UINavigationController *dvdsNavigationViewController = [[UINavigationController alloc] initWithRootViewController:dvdsViewController];
    dvdsNavigationViewController.navigationBar.barTintColor = [UIColor colorWithRed:50.0 / 255
                                                                                green:68.0 / 255
                                                                                 blue:83.0 / 255
                                                                                alpha:1.0];
    dvdsNavigationViewController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Initialize tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[moviesNavigationViewController, dvdsNavigationViewController];
    
    tabBarController.tabBar.barTintColor = [UIColor colorWithRed:50.0 / 255
                                                           green:68.0 / 255
                                                            blue:83.0 / 255
                                                           alpha:1.0];
    tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    // Set root view controller
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
