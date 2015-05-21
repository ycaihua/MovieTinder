//
//  TTImageView.m
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import "TTImageView.h"

@implementation TTImageView {
    @private
    NSURLSessionDownloadTask *_task;
}

- (void)dealloc
{
    if (_task != nil) {
        [_task cancel];
    }
}

- (void)downloadImageURL:(NSURL *)url
{
    if (_task != nil) {
        [_task cancel];
    }
    
    // Note: For here I would have wanted to cache the download to a file, but for this excercise I left it out
    
    _task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        @autoreleasepool {
            _task = nil;
            
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data scale:[[UIScreen mainScreen] scale]];
            
            __weak TTImageView *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong TTImageView *__self = weakSelf;
                __self.image = image;
            });
        }
    }];
    [_task resume];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.window == nil) {
        [_task cancel];
    }
}

@end
