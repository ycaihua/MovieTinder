//
//  TTEntry.h
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTEntry : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSString *label;
@property (nonatomic, readonly) NSString *summary;
@property (nonatomic, readonly) NSURL *thumbnail;

@end
