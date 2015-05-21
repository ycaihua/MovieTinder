//
//  TTMovieListDataController.h
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const TTMovieListDataUpdated;

@interface TTMovieListDataController : NSObject

@property (nonatomic, readonly) NSArray *entries;

- (void)fetchTopListFromApple;
- (void)cancelFetch;

@end
