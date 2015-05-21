//
//  AppDelegate+TTNetworkHelpers.m
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import "AppDelegate+TTNetworkHelpers.h"
#import <libkern/OSAtomic.h>

NSString * const TTNetworkFetchStarted = @"TTNetworkFetchStarted";
NSString * const TTNetworkFetchFinished = @"TTNetworkFetchFinished";

volatile int32_t _networkActivity;

@implementation AppDelegate (TTNetworkHelpers)

- (void)setupNetworkActivityMonitor
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incrementNetworkActivity) name:TTNetworkFetchStarted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decrementNetworkActivity) name:TTNetworkFetchFinished object:nil];
}

#pragma mark -

- (void)incrementNetworkActivity
{
    OSAtomicIncrement32(&_networkActivity);
    
    if (_networkActivity > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
    }
}

- (void)decrementNetworkActivity
{
    OSAtomicDecrement32(&_networkActivity);
    
    if (_networkActivity < 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }
}

@end
