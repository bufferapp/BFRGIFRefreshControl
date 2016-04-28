//
//  AppDelegate.m
//  GifRefresh
//
//  Created by Jordan Morgan on 4/28/16.
//  Copyright © 2016 Buffer, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "GifFromBundleTableViewController.h"
#import "GifFromURLTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Set up tab controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    UITabBarController *tabVC = [UITabBarController new];
    [tabVC.tabBar setBackgroundColor:[UIColor whiteColor]];
    [tabVC.tabBar setTranslucent:NO];
    
    GifFromBundleTableViewController *gifFromBundleVC = [GifFromBundleTableViewController new];
    gifFromBundleVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Bundle" image:[UIImage imageNamed:@"media"] tag:0];
    UINavigationController *navBundleVC = [[UINavigationController alloc] initWithRootViewController:gifFromBundleVC];
    
    GifFromURLTableViewController *gifFromURLVC = [GifFromURLTableViewController new];
    gifFromURLVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"URL" image:[UIImage imageNamed:@"network"] tag:0];
    UINavigationController *navURLVC = [[UINavigationController alloc] initWithRootViewController:gifFromURLVC];
    
    tabVC.viewControllers = @[navBundleVC, navURLVC];
    self.window.rootViewController = tabVC;
    
    return YES;
}



@end
