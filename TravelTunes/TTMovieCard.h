//
//  TTMovieCard.h
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTEntry;
@class TTMovieCard;

extern NSString * const TTMovieCardAnimationStarted;
extern NSString * const TTMovieCardAnimationFinished;

@protocol TTMovieCardDelegate <NSObject>

- (void)userDraggedCardRight:(TTMovieCard *)card;
- (void)userDraggedCardLeft:(TTMovieCard *)card;

@end

typedef NS_ENUM(NSInteger, TTMovieCardPosition) {
    TTMovieCardPosition1,
    TTMovieCardPosition2,
    TTMovieCardPosition3
};

typedef NS_ENUM(NSInteger, TTMovieCardSpeed) {
    TTMovieCardSpeedFast = 0,
    TTMovieCardSpeedSlow
};

@interface TTMovieCard : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) TTEntry *entry;
@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, weak) id <TTMovieCardDelegate> delegate;

@property (nonatomic) TTMovieCardPosition position;

- (void)prepareForReuse;

- (void)moveCardToRight:(TTMovieCardSpeed)speed;
- (void)moveCardToLeft:(TTMovieCardSpeed)speed;

@end
