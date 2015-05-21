//
//  AppDelegate.m
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import "AppDelegate.h"
#import "TTSwipeViewController.h"
#import "AppDelegate+TTNetworkHelpers.h"

@implementation AppDelegate

- (void)setupApplicationWindow
{
    TTSwipeViewController *vc = [[TTSwipeViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = navController;
    [window makeKeyAndVisible];
    
    window.tintColor = [UIColor colorWithRed:247.f/255.f green:128.f/255.f blue:67.f/255.f alpha:1.f];
    self.window = window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupApplicationWindow];
    [self setupNetworkActivityMonitor];
    
    return YES;
}

@end
