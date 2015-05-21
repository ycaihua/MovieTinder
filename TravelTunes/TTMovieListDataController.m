//
//  TTMovieListDataController.m
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import "TTMovieListDataController.h"
#import "TTEntry.h"
#import "TTImageView.h"
#import "AppDelegate+TTNetworkHelpers.h"


NSString * const TTMovieListDataUpdated = @"TTMovieListDataUpdated";

@implementation TTMovieListDataController {
    @private
    NSURLSessionTask *_task;
}

- (void)dealloc
{
    _entries = nil;
    [self cancelFetch];
}

- (void)fetchTopListFromApple
{
    if (_task != nil) {
        [_task cancel];
    }
    
    _entries = nil;
    
    NSString *path = @"https://itunes.apple.com/us/rss/topmovies/limit=100/genre=4401/json";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = @"GET";
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTNetworkFetchStarted object:nil];
    _task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationName:TTNetworkFetchFinished object:nil];
            
            if (error != nil) {
                return;
            }
            
            NSError *jsonErr = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
            
            if (jsonErr != nil) {
                return;
            }
            
            NSArray *entries = result[@"feed"][@"entry"];
            if ([entries count] == 0) {
                return;
            }
            
            NSMutableArray *fullEntries = [@[] mutableCopy];
            for (NSDictionary *entry in entries) {
                TTEntry *fullEntry = [[TTEntry alloc] initWithDictionary:entry];
                [fullEntries addObject:fullEntry];
            }
            
            __weak TTMovieListDataController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong TTMovieListDataController *__self = weakSelf;
                
                if (__self)
                    __self->_entries = fullEntries;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:TTMovieListDataUpdated object:__self];
            });
        }
    }];
    [_task resume];
}

- (void)cancelFetch
{
    if (_task != nil) {
        [_task cancel];
        _task = nil;
    }
}

@end
