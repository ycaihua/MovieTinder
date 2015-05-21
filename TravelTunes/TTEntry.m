//
//  TTEntry.m
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import "TTEntry.h"

@implementation TTEntry {
    @private
    NSDictionary *_original;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _original = dictionary;
    
    return self;
}

// Note: I'd like to make sure these types exist and are actually dictionaries

- (NSString *)label
{
    NSDictionary *name = _original[@"im:name"];
    return name[@"label"];
}

- (NSURL *)thumbnail
{
    NSArray *thumbs = _original[@"im:image"];
    NSDictionary *thumb = [thumbs lastObject];
    
    return [NSURL URLWithString:thumb[@"label"]];
}

- (NSString *)summary
{
    NSDictionary *summary = _original[@"summary"];
    return summary[@"label"];
}

@end
