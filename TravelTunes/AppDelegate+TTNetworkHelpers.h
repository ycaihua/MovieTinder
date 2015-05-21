//
//  AppDelegate+TTNetworkHelpers.h
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import "AppDelegate.h"

extern NSString * const TTNetworkFetchStarted;
extern NSString * const TTNetworkFetchFinished;

@interface AppDelegate (TTNetworkHelpers)

- (void)setupNetworkActivityMonitor;

- (void)incrementNetworkActivity;
- (void)decrementNetworkActivity;

@end
